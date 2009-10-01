From: "Florian Fuessl" <flo@degnet.de>
Subject: RE: T.38 FAX support via nf_nat_sip,nf_conntrack_sip
Date: Thu, 1 Oct 2009 17:48:19 +0200
Message-ID: <003201ca42ae$998651e0$cc92f5a0$@de>
References: <002401ca405e$91c4ae90$b54e0bb0$@de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Florian Fuessl'" <flo@degnet.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail04.viruscheckservice.de ([80.73.96.84]:65217 "EHLO
	mail04.viruscheckservice.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbZJAPsP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:48:15 -0400
In-Reply-To: <002401ca405e$91c4ae90$b54e0bb0$@de>
Content-Language: de
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've an update regarding this issue:

According to my packet dumps the nf_conntrack_sip.c function:

static int process_sdp(struct sk_buff *skb,
                       const char **dptr, unsigned int *datalen,
                       unsigned int cseq)
{
[...]
        /* Update session connection and owner addresses */
        nf_nat_sdp_session = rcu_dereference(nf_nat_sdp_session_hook);
        if (nf_nat_sdp_session && ct->status & IPS_NAT_MASK)
                ret = nf_nat_sdp_session(skb, dptr, sdpoff, datalen,
&rtp_addr);

        if (ret == NF_ACCEPT && i > 0)
                help->help.ct_sip_info.invite_cseq = cseq;

        return ret;
}

... seems to rewrite the SIP/SDP (IN IP4) owner address and connection
address with garbage IP data on REINVITE packets sourcing from NAT outbound
to NAT inbound.

For example:
REINVITE packet sourcing from NAT outbound with connection information:
SIP Call IN IP4 212.77.188.67
... will be rewritten by the garbage IP address:
SIP Call IN IP4 128.41.188.128

Should this information not only be rewritten for packets sourcing from NAT
inbound to NAT outbound? 
What information does nf_nat_sip,nf_conntrack_sip read in order to determine
the garbage IP? Is this maybe a security (buffer) problem, too?

Sorry I'm no coder, so any help is very welcome :)

-Florian

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of Florian Fuessl
> Sent: Monday, September 28, 2009 7:10 PM
> To: netfilter-devel@vger.kernel.org
> Subject: T.38 FAX support via nf_nat_sip,nf_conntrack_sip
> 
> Hi,
> 
> T.38 FAX support via nf_nat_sip,nf_conntraack_sip does currently not
> seem to
> work, because the REINVITE for the codec change is not handled
> correctly at
> the moment (Figure: Fax Pass-Through and Call Flow diagram i.e. at
> http://docwiki.cisco.com/wiki/Cisco_IOS_Voice_Troubleshooting_and_Monit
> oring
> _--_Fax_Call_Flow )
> 
> Do you have an idea how to patch this problem?
> 
> -Florian
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-
> devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

