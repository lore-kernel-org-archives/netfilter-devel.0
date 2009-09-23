From: "Chang, Richard (Cont, ARL/CISD)" <rachang@arl.army.mil>
Subject: dev_queue_xmit is hanging on packet delivery (UNCLASSIFIED)
Date: Wed, 23 Sep 2009 13:41:59 -0400
Message-ID: <8B40037CAD71384FBD524ED1E5351A9E01C1F7@ADLCAML01.DS.ARL.ARMY.MIL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arlabbh01.ds.arl.army.mil ([192.12.65.18]:1364 "EHLO
	ARLABBH01.ds.arl.army.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZIWR5I convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:57:08 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Classification: UNCLASSIFIED
Caveats: NONE

I'm not sure if this is the right group, but my question is about
reinjecting packets  after modification.   I wrote a simple kernel
module which took a skb, copied it with skb_clone(skb), called
dev_queue_xmit(cloned_skb) and returned NF_STOLEN.  

unsigned int process_outgoing( unsigned int hooknum,
				struct sk_buff **skb,
				...
)
struct sk_buff *skbuf = skb_copy(*skb, GFP_ATOMIC);
...
...
int rtval;

If(!skbuf)
	Return NF_ACCEPT;
...
...

rtval = dev_queue_xmit(skbuf);
if( rtval == NET_XMIT_SUCCESS)
	printk("Great packet queued\n");
else
{
	printk("packet not resent\n")
}

return NF_STOLEN;
}

After installing this module, my client/server application transmits the
first packet then hangs.  Nothing else is received on both ends.  If I
remove the module, packet will slowly begin to be received.  Admittedly
there is a lot that I don't understand about netfilters, but this makes
absolutely no sense to me.  I can't seem find a lot of documentation
about reinjecting packets.  I came across the function
nf_reinject(skb,nf_info,verdict)  but I have no idea where the middle
parameter is coming from or how this verdict is affecting the return
value of my process_outgoing function of my kernel mod.  Both
documentation lacks sample implementation.  Again, I simply want to
capture packets, modify them, then reinject them to their incoming or
outgoing queue.

I appreciate any help.

Thanx Richard  
Classification: UNCLASSIFIED
Caveats: NONE


