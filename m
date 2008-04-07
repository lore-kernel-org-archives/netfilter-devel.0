From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Subject: Re: DCCP conntrack/NAT
Date: Mon, 7 Apr 2008 22:50:17 +0100
Message-ID: <20080407215017.GB8682@gerrit.erg.abdn.ac.uk>
References: <47F64C0D.5080700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:45013 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447AbYDGVuX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:50:23 -0400
Content-Disposition: inline
In-Reply-To: <47F64C0D.5080700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have had a look at the connection-tracker and it proved a valuable exercise in re-reading the specs.

Some comments itemised below.

 * nf_conntrack_proto_dccp.c:
   - 8.1.2. Client Request 
     o reference is 8.1.1, not 8.1.2
     o the Linux implementation uses same method as TCP handshake
       (and is currently the only available DCCP implementation),
       so can probably reuse TCP timeout values here -- the rules
       in RFC 4340 are not exactly clear.
   - typo: state transistion table
           OPEN: RPcket

 * just curious about timeout for OPEN state: it is set to 
   a full working week (5 * 24 * 3600 seconds). There is this
   wrap-around of DCCP timestamps after 11.2 hours, so maybe
   the Open state can be curtailed.
 
 * Ignoring Sync/SyncAck packets: if this means they can get
   through, then it is good, since for instance CCID-2 may use
   a Sync for out-of-band information; RFC 4340 mentions Syncs
   for similar purposes (e.g. feature negotiation); and Syncs
   can appear in both directions.
 
 * for the timeout sysctls, use proc_dointvec_ms_jiffies ?

 * the state table has dimension DCCP_PKT_SYNCACK + 1, but what if 
   a value greater than that appears in the dccp header in the statement
   state = dccp_state_table[IP_CT_DIR_ORIGINAL][dh->dccph_type][CT_DCCP_NONE];

 * dccp_ack_seq() duplicates code from include/linux/dccp.h:
   could use dccp_hdr_ack_seq() instead.


	State Transitions in the original direction
	===========================================

 * DCCP-Request:
   - in state Respond (sRS -> sRS), the Request is illegal (Respond is server state)
   - also, the CLOSEREQ state transition (sCR -> sIG) is illegal: Requests are sent 
     by clients only, and CLOSEREQ can only be entered by servers
   - timewait transition -- question: is it possible to re-incarnate a new connection
     here instead of ignoring the (new) Request?

 * DCCP-DataAck:
   - the transition sRS should go to sPO (Partopen). This is because the client
     can send data when it has received the Response from the server, i.e. it
     is the same rule as for DCCP-Ack in state sRS (cf. RFC 4340, 8.1.5). The "Ack"
     in the DataAck has the same effect as an Ack in sRS, it acknowledges the 
     Response and thus triggers transition to Partopen.


	State Transitions in the reply direction
	========================================

 * DCCP-CloseReq:
   - the transition from sCG is a simultaneous-close, which is possible
     (both sides performing active-close, server sends CloseReq after client has
      sent a Close) and has been seen on the wire, cf.
      http://www.erg.abdn.ac.uk/users/gerrit/dccp/notes/closing_states/ )
   - use "ignore" here?


 * DCCP-Close:
   - the transition sCR -> sCG: I wonder if that is possible --
     o if the client is behind the NAT, it means the server sent a Close after
       a CloseReq, which is invalid
     o but if (hopefully soon) a server is behind a NAT, this would mean that 
       the server had previously sent a CloseReq which now crosses paths with
       a Close from the client in the reverse direction -- again a simultaneous
       close, in this case sCR -> sCR would be possible
     o simplest option - maybe better to use sCR -> sIG or drop packet.


The University of Aberdeen is a charity registered in Scotland, No SC013683.

