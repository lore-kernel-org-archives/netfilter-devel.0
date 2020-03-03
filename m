Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F19CC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6038205ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="VErE2Zew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgCCJg7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:36:59 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:50671 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728045AbgCCJg7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 04:36:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 3DA2DCC00F3;
        Tue,  3 Mar 2020 10:36:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1583228214; x=1585042615; bh=5FVrDeZsp1
        t0gaw/zGPrvUKcVmpTJQd7tqIhkhPETZA=; b=VErE2ZewpJvFYuJPNzDPS4Odl5
        GnkHaippRQb7B5me7+xFr90yJwDJgR4KQ6oUsADJPTlZRsSRxIcIHenxFLjVcHos
        9BPiiawyz8SA306wKQbesoKs69rhG/KFQmNZr833ooYEvR2I8NXAXDIGT4QER2Zh
        TZiNMQsw4qfWLvqvs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue,  3 Mar 2020 10:36:54 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id E7951CC00E6;
        Tue,  3 Mar 2020 10:36:53 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BF62E21229; Tue,  3 Mar 2020 10:36:53 +0100 (CET)
Date:   Tue, 3 Mar 2020 10:36:53 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200228124039.00e5a343@redhat.com>
Message-ID: <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com> <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu> <20200225094043.5a78337e@redhat.com> <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu> <20200225132235.5204639d@redhat.com>
 <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu> <20200225215322.6fb5ecb0@redhat.com> <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu> <20200228124039.00e5a343@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Fri, 28 Feb 2020, Stefano Brivio wrote:

> On Thu, 27 Feb 2020 21:37:10 +0100 (CET)
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> 
> > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > 
> > > On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > >   
> > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > >   
> > > > > > The logic could be changed in the user rules from
> > > > > > 
> > > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > > > 
> > > > > > to
> > > > > > 
> > > > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > > > > [ otherwise DROP ]
> > > > > > 
> > > > > > but of course it might be not so simple, depending on how the rules are 
> > > > > > built up.    
> > > > > 
> > > > > Yes, it would work, unless the user actually wants to check with the
> > > > > same counter how many bytes are sent "in excess".    
> > > > 
> > > > You mean the counters are still updated whenever the element is matched in 
> > > > the set and then one could check how many bytes were sent over the 
> > > > threshold just by listing the set elements.  
> > > 
> > > Yes, exactly -- note that it was possible (and, I think, used) before.  
> > 
> > I'm still not really convinced about such a feature. Why is it useful to 
> > know how many bytes would be sent over the "limit"?
> 
> This is useful in case one wants different treatments for packets
> according to a number of thresholds in different rules. For example,
> 
>     iptables -I INPUT -m set --match-set c src --bytes-lt 100 -j noise
>     iptables -I noise -m set --match-set c src --bytes-lt 20000 -j download
> 
> and you want to log packets from chains 'noise' and 'download' with
> different prefixes.

What do you think about this patch?

diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index 7545af4..6881329 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -186,6 +186,9 @@ enum ipset_cmd_flags {
 	IPSET_FLAG_MAP_SKBPRIO = (1 << IPSET_FLAG_BIT_MAP_SKBPRIO),
 	IPSET_FLAG_BIT_MAP_SKBQUEUE = 10,
 	IPSET_FLAG_MAP_SKBQUEUE = (1 << IPSET_FLAG_BIT_MAP_SKBQUEUE),
+	IPSET_FLAG_BIT_UPDATE_COUNTERS_FIRST = 11,
+	IPSET_FLAG_UPDATE_COUNTERS_FIRST =
+		(1 << IPSET_FLAG_BIT_UPDATE_COUNTERS_FIRST),
 	IPSET_FLAG_CMD_MAX = 15,
 };
 
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index 1df6536..423d0de 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -622,10 +622,9 @@ ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
 
 static void
 ip_set_update_counter(struct ip_set_counter *counter,
-		      const struct ip_set_ext *ext, u32 flags)
+		      const struct ip_set_ext *ext)
 {
-	if (ext->packets != ULLONG_MAX &&
-	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
+	if (ext->packets != ULLONG_MAX) {
 		ip_set_add_bytes(ext->bytes, counter);
 		ip_set_add_packets(ext->packets, counter);
 	}
@@ -649,13 +648,19 @@ ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 	if (SET_WITH_COUNTER(set)) {
 		struct ip_set_counter *counter = ext_counter(data, set);
 
+		if (flags & IPSET_FLAG_UPDATE_COUNTERS_FIRST)
+			ip_set_update_counter(counter, ext);
+
 		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
 		    !(ip_set_match_counter(ip_set_get_packets(counter),
 				mext->packets, mext->packets_op) &&
 		      ip_set_match_counter(ip_set_get_bytes(counter),
 				mext->bytes, mext->bytes_op)))
 			return false;
-		ip_set_update_counter(counter, ext, flags);
+
+		if (!(flags & (IPSET_FLAG_UPDATE_COUNTERS_FIRST|
+			       IPSET_FLAG_SKIP_COUNTER_UPDATE)))
+			ip_set_update_counter(counter, ext);
 	}
 	if (SET_WITH_SKBINFO(set))
 		ip_set_get_skbinfo(ext_skbinfo(data, set),

Then the rules above would look like

... -m set ... --update-counters-first --bytes-lt 100 -j noise
... -m set ... --update-counters-first --bytes-ge 100 -j download
 
> > > What I meant is really the case where "--update-counters" (or 
> > > "--force-update-counters") and "! --update-counters" are both 
> > > absent: I don't see any particular advantage in the current 
> > > behaviour for that case.
> > 
> > The counters are used just for statistical purposes: reflect the 
> > packets/bytes which were let through, i.e. matched the whole "rule". 
> > In that case updating the counters before the counter value matching 
> > is evaluated gives false results.
> 
> Well, but for that, iptables/x_tables counters are available and (as far 
> as I know) typically used.

With "rules" I meant at ipset level (match element + packet/byte counters 
as specified), i.e. counters for statistical purposes per set elements 
level.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
