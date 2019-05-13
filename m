Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F863C04AA7
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 11:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB1AF208C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 11:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfEML0n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 07:26:43 -0400
Received: from mail.us.es ([193.147.175.20]:49408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfEML0m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 07:26:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9556311FBEB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 13:26:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81752DA7B5
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 13:26:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7EB11DA799; Mon, 13 May 2019 13:26:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47C80DA78C;
        Mon, 13 May 2019 13:26:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 13:26:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 22E854044284;
        Mon, 13 May 2019 13:26:32 +0200 (CEST)
Date:   Mon, 13 May 2019 13:26:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     xiao ruizhu <katrina.xiaorz@gmail.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        alin.nastac@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nf_conntrack_sip: fix expectation clash
Message-ID: <20190513112631.zmrcyss5bqr53yo4@salvia>
References: <20190321105607.dwj3wtxe32cenglo@salvia>
 <1555317180-3074-1-git-send-email-katrina.xiaorz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555317180-3074-1-git-send-email-katrina.xiaorz@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 15, 2019 at 04:33:00PM +0800, xiao ruizhu wrote:
[...]
> When conntracks change during a dialog, SDP messages may be sent from
> different conntracks to establish expects with identical tuples. In this
> case expects conflict may be detected for the 2nd SDP message and end up
> with a process failure.
> 
> The fixing here is to check both RTP and RTCP expect existence before
> creation. When there is an existing expect with the same tuples for a
> different conntrack, reuse it.
> 
> Here are two scenarios for the case.
> 
> 1)
>          SERVER                   CPE
> 
>            |      INVITE SDP       |
>       5060 |<----------------------|5060
>            |      100 Trying       |
>       5060 |---------------------->|5060
>            |      183 SDP          |
>       5060 |---------------------->|5060    ===> Conntrack 1
>            |       PRACK           |
>      50601 |<----------------------|5060
>            |    200 OK (PRACK)     |
>      50601 |---------------------->|5060
>            |    200 OK (INVITE)    |
>       5060 |---------------------->|5060
>            |        ACK            |
>      50601 |<----------------------|5060
>            |                       |
>            |<--- RTP stream ------>|
>            |                       |
>            |    INVITE SDP (t38)   |
>      50601 |---------------------->|5060    ===> Conntrack 2
> 
> With a certain configuration in the CPE, SIP messages "183 with SDP" and
> "re-INVITE with SDP t38" will go through the sip helper to create
> expects for RTP and RTCP.
> 
> It is okay to create RTP and RTCP expects for "183", whose master
> connection source port is 5060, and destination port is 5060.
> 
> In the "183" message, port in Contact header changes to 50601 (from the
> original 5060). So the following requests e.g. PRACK and ACK are sent to
> port 50601. It is a different conntrack (let call Conntrack 2) from the
> original INVITE (let call Conntrack 1) due to the port difference.
> 
> In this example, after the call is established, there is RTP stream but no
> RTCP stream for Conntrack 1, so the RTP expect created upon "183" is
> cleared, and RTCP expect created for Conntrack 1 retains.
> 
> When "re-INVITE with SDP t38" arrives to create RTP&RTCP expects, current
> ALG implementation will call nf_ct_expect_related() for RTP and RTCP. The
> expects tuples are identical to those for Conntrack 1. RTP expect for
> Conntrack 2 succeeds in creation as the one for Conntrack 1 has been
> removed. RTCP expect for Conntrack 2 fails in creation because it has
> idential tuples and 'conflict' with the one retained for Conntrack 1. And
> then result in a failure in processing of the re-INVITE.
> 
> 2)
> 
>     SERVER A                 CPE
> 
>        |      REGISTER     |
>   5060 |<------------------| 5060  ==> CT1
>        |       200         |
>   5060 |------------------>| 5060
>        |                   |
>        |   INVITE SDP(1)   |
>   5060 |<------------------| 5060
>        | 300(multi choice) |
>   5060 |------------------>| 5060                    SERVER B
>        |       ACK         |
>   5060 |<------------------| 5060
>                                   |    INVITE SDP(2)    |
>                              5060 |-------------------->| 5060  ==> CT2
>                                   |       100           |
>                              5060 |<--------------------| 5060
>                                   | 200(contact changes)|
>                              5060 |<--------------------| 5060
>                                   |       ACK           |
>                              5060 |-------------------->| 50601 ==> CT3
>                                   |                     |
>                                   |<--- RTP stream ---->|
>                                   |                     |
>                                   |       BYE           |
>                              5060 |<--------------------| 50601
>                                   |       200           |
>                              5060 |-------------------->| 50601
>        |   INVITE SDP(3)   |
>   5060 |<------------------| 5060  ==> CT1
> 
> CPE sends an INVITE request(1) to Server A, and creates a RTP&RTCP expect
> pair for this Conntrack 1 (CT1). Server A responds 300 to redirect to
> Server B. The RTP&RTCP expect pairs created on CT1 are removed upon 300
> response.
> 
> CPE sends the INVITE request(2) to Server B, and creates an expect pair
> for the new conntrack (due to destination address difference), let call
> CT2. Server B changes the port to 50601 in 200 OK response, and the
> following requests ACK and BYE from CPE are sent to 50601. The call is
> established. There is RTP stream and no RTCP stream. So RTP expect is
> removed and RTCP expect for CT2 retains.
> 
> As BYE request is sent from port 50601, it is another conntrack, let call
> CT3, different from CT2 due to the port difference. So the BYE request will
> not remove the RTCP expect for CT2.
> 
> Then another outgoing call is made, with the same RTP port being used (not
> definitely but possibly). CPE firstly sends the INVITE request(3) to Server
> A, and tries to create a RTP&RTCP expect pairs for this CT1. In current ALG
> implementation, the RTCP expect for CT1 fails in creation because it
> 'conflicts' with the residual one for CT2. As a result the INVITE request
> fails to send.
> 
> Signed-off-by: xiao ruizhu <katrina.xiaorz@gmail.com>
> ---
> Changes in v3:
> - take Pablo's advice about the comments, nf_conntrack_expect_lock and
>   nf_ct_sip_expect_exists()
> - change the policy to reuse the exising expect(s) instead of removal then
>   recreation, to avoid CPU cycle waste
> Changes in v2:
> - add a comment on release_conflicting_expect functionality
> - move local variable errp to the beginning of the block
> v1:
> - original patch
> ---
>  net/netfilter/nf_conntrack_sip.c | 45 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index f067c6b..0e17c14 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -799,6 +799,31 @@ static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
>  	return 1;
>  }
>  
> +static bool nf_ct_sip_expect_exists(const struct nf_conntrack_expect *expect,
> +				    const struct nf_conn *ct,
> +				    enum sip_expectation_classes class)
> +{
> +	return (expect && expect->master != ct &&
> +		nfct_help(expect->master)->helper == nfct_help(ct)->helper &&
> +		expect->class == class);
> +}
> +
> +/* Look for an expect with identical tuple but for a different master. */
> +static bool nf_ct_sip_expect_found(const struct nf_conntrack_expect *expect,
> +				   const struct nf_conn *ct)
> +{
> +	struct nf_conntrack_expect *exp;
> +	struct net *net = nf_ct_net(ct);
> +	bool found = 0;
> +
> +	spin_lock_bh(&nf_conntrack_expect_lock);
> +	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &expect->tuple);

__nf_ct_expect_find() may return NULL.

> +	found = nf_ct_sip_expect_exists(exp, ct, expect->class);
> +	spin_unlock_bh(&nf_conntrack_expect_lock);
> +
> +	return found;
> +}
> +
>  static int refresh_signalling_expectation(struct nf_conn *ct,
>  					  union nf_inet_addr *addr,
>  					  u8 proto, __be16 port,
> @@ -929,9 +954,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
>  	do {
>  		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
>  
> -		if (!exp || exp->master == ct ||
> -		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
> -		    exp->class != class)
> +		if (!nf_ct_sip_expect_exists(exp, ct, class))
>  			break;
>  #ifdef CONFIG_NF_NAT_NEEDED
>  		if (!direct_rtp &&
> @@ -983,11 +1006,23 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
>  		/* -EALREADY handling works around end-points that send
>  		 * SDP messages with identical port but different media type,
>  		 * we pretend expectation was set up.
> +		 * It also works in the case that SDP messages are sent with
> +		 * identical expect tuples but for different master conntracks.
>  		 */
> -		int errp = nf_ct_expect_related(rtp_exp);
> +		int errp;
> +
> +		if (nf_ct_sip_expect_found(rtp_exp, ct))
> +			errp = -EALREADY;
> +		else
> +			errp = nf_ct_expect_related(rtp_exp);

I wonder if we can handle this from __nf_ct_expect_check() itself.

We could just check if master mismatches, then return -EALREADY from
there?

Similar to 876c27314ce51, but catch the master mismatches case.

>  		if (errp == 0 || errp == -EALREADY) {
> -			int errcp = nf_ct_expect_related(rtcp_exp);
> +			int errcp;
> +
> +			if (nf_ct_sip_expect_found(rtcp_exp, ct))
> +				errcp = -EALREADY;
> +			else
> +				errcp = nf_ct_expect_related(rtcp_exp);
>  
>  			if (errcp == 0 || errcp == -EALREADY)
>  				ret = NF_ACCEPT;
> -- 
> 1.9.1
> 
