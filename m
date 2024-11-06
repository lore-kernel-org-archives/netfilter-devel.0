Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F1E1DD53E
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 10:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887816; cv=none; b=tN9Kp+1XM4kdmleQv7alxVtsaOZKER4X5cgoYBAg5Y8LSQQDguGrXqrvu57wGe5Y2vow9P2osSKlMsSS8kF/bzKM0keqe2Vr+7iyCPymXVunkdnjPOM6f7rDIipO/mHc2J3greM4q5xAKmkHfzdFBxyiOW9+N37EacWWv9PLgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887816; c=relaxed/simple;
	bh=+aS1ET6jkn4CoJ4NrmTHr0q1Dem9EibVdnb6/9zyxfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fot05qnfb0OkLd0cC+XN3Eea62htHU1aZGQLi08wcsK9AzMklwqN0IHIPbvdwqDKG0baON6nrjoCOv3yGdq76AlQJqVwVKJHPBHXVblHdfIWk3iqKPxcM8t/hGeWxuRsp4KWNtg0l/Oqpqu6V6Hwfx+Hz9FFSozG7SMCwZw7w9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GwNtrJYg; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GwNtrJYg"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53a0c160b94so7301615e87.2
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Nov 2024 02:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730887812; x=1731492612; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fNO6TGKP/+LQGTPQEH2ybPyla4jnyhP1frtZSy04ZSg=;
        b=GwNtrJYgMoxTvHg3tB569UKctS85N+wRy7Zv9kdoCU9cFw+91GZG6UZWYLo6KsNBnf
         p5KqyorRWSKmUab9l0J+JIFv5Vw5+UlxZwou/pYfNr5HzIjYmtum7DiYOxceHZemx/sp
         TpdDLfyGoIB2kqHSf/4LsImOOrTCTLx3ZYDOLPMPnNsqQmJQl+I+SVVH6CvUgeuqkpRQ
         b+KcTqfM7gZvgYUKR25p9SMIYakZ1WNPrjWBFYzzrfFdF7LSbXgzsAU840wyi9H03eFx
         QOasGB16nZjz47HA5EOe5N9cvctGX7ZHwEOBtWomf0eowwkY/e4R3mRGpv553Cm0soUc
         Omhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730887812; x=1731492612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNO6TGKP/+LQGTPQEH2ybPyla4jnyhP1frtZSy04ZSg=;
        b=go3z6bq9qtm32nnyzgjuyrq84Hh2sjIXtEXDh2jUeoHtKzzXX4sVZ4qbMgcpbWw+RI
         JYSqD+GmOvJqCy44wnyhI43A9XohdjDolZ+Ge6US429EygfXW3FPqe+bI02GSfj35pBO
         0gvSOChK+tnfZvmOzM8QN9NoC+wDXCQ/A1HicOrWgLwPmvaaV9/LIpdDXD4nKpbWOec4
         oWNRkilM+Xmu18MgvtfZcGGarhrTSciQ4gwAolgkYbDblQ68vvYChIQQic0m0wWHXVes
         w0EmAnXnRRXTKGdKaA2gXfKOPP+tGRLLu2KaBiMJBFXwjQhw+wLHVrgCAdgoQ+SnVb/Y
         qvRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyTwUEbY8HXW53KOvvJ1Qk20DXkduVJlUW2VrXP8TuWeQqpOgqs7qznI0fQ4Kk/ufJo/hYNA4P7AB2LP0jHZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFvBgvCN+CL41B7bL12D8cGpq5Rr5YzDtMBert3nHBccNqSdq1
	s+nWAmuELbzrhoX/2qxr6G+QegSvOb9B4pp054A0WdVJZgVV2sVpzVjt4tX5TyU=
X-Google-Smtp-Source: AGHT+IFIuECaW7xkmKog/6XR3Bm1cVBXq3+1kroSkbNlM+eANJYtdB1ZBSYvMEA1NdvAO5iq4+lLAw==
X-Received: by 2002:a05:6512:124c:b0:530:aeea:27e1 with SMTP id 2adb3069b0e04-53d65e26545mr9011252e87.50.1730887811686;
        Wed, 06 Nov 2024 02:10:11 -0800 (PST)
Received: from localhost ([89.101.134.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa70a23fsm17442335e9.33.2024.11.06.02.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 02:10:11 -0800 (PST)
Date: Wed, 6 Nov 2024 13:10:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [bug report] lsm: replace context+len with lsm_context
Message-ID: <89c37084-f3ac-4cad-b480-86c9f4cb7eb4@suswa.mountain>
References: <549fd50d-a631-4103-bfe2-e842de387163@stanley.mountain>
 <Zyn9oJ9oxltqbK0x@calendula>
 <06e25ad3-bb68-416c-8f19-5bdedf38029e@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06e25ad3-bb68-416c-8f19-5bdedf38029e@schaufler-ca.com>

On Tue, Nov 05, 2024 at 12:09:49PM -0800, Casey Schaufler wrote:
> On 11/5/2024 3:12 AM, Pablo Neira Ayuso wrote:
> > Hi,
> >
> > There is another issue in this recent series, see below.
> >
> > This needs another follow up.
> 
> Dan Carpenter sent a patch:
> 
> https://lore.kernel.org/lkml/b226a01a-2545-4b67-9cc6-59cfa0ffabbc@schaufler-ca.com/
> 

Sorry for the confusion.  That was for a separate simpler issue.  I was
confused about this line here.

785          if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))

regards,
dan carpenter

> >
> > Thanks.
> >
> > On Sat, Nov 02, 2024 at 12:21:01PM +0300, Dan Carpenter wrote:
> >> Hello Casey Schaufler,
> >>
> >> Commit 95a3c11eb670 ("lsm: replace context+len with lsm_context")
> >> from Oct 23, 2024 (linux-next), leads to the following Smatch static
> >> checker warning:
> >>
> >>   net/netfilter/nfnetlink_queue.c:646 nfqnl_build_packet_message()
> >>   warn: always true condition '(seclen >= 0) => (0-u32max >= 0)'
> >>
> >>   net/netfilter/nfnetlink_queue.c:813 nfqnl_build_packet_message()
> >>   warn: always true condition '(seclen >= 0) => (0-u32max >= 0)'
> >>
> >>   net/netfilter/nfnetlink_queue.c:822 nfqnl_build_packet_message()
> >>   warn: always true condition '(seclen >= 0) => (0-u32max >= 0)'
> >>
> >> net/netfilter/nfnetlink_queue.c
> >>    551  static struct sk_buff *
> >>    552  nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >>    553                             struct nf_queue_entry *entry,
> >>    554                             __be32 **packet_id_ptr)
> >>    555  {
> >>    556          size_t size;
> >>    557          size_t data_len = 0, cap_len = 0;
> >>    558          unsigned int hlen = 0;
> >>    559          struct sk_buff *skb;
> >>    560          struct nlattr *nla;
> >>    561          struct nfqnl_msg_packet_hdr *pmsg;
> >>    562          struct nlmsghdr *nlh;
> >>    563          struct sk_buff *entskb = entry->skb;
> >>    564          struct net_device *indev;
> >>    565          struct net_device *outdev;
> >>    566          struct nf_conn *ct = NULL;
> >>    567          enum ip_conntrack_info ctinfo = 0;
> >>    568          const struct nfnl_ct_hook *nfnl_ct;
> >>    569          bool csum_verify;
> >>    570          struct lsm_context ctx;
> >>    571          u32 seclen = 0;
> >>                 ^^^^^^^^^^
> >>
> >>    572          ktime_t tstamp;
> >>    573  
> >>    574          size = nlmsg_total_size(sizeof(struct nfgenmsg))
> >>    575                  + nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
> >>    576                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> >>    577                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> >>    578  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> >>    579                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> >>    580                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> >>    581  #endif
> >>    582                  + nla_total_size(sizeof(u_int32_t))     /* mark */
> >>    583                  + nla_total_size(sizeof(u_int32_t))     /* priority */
> >>    584                  + nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
> >>    585                  + nla_total_size(sizeof(u_int32_t))     /* skbinfo */
> >>    586  #if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
> >>    587                  + nla_total_size(sizeof(u_int32_t))     /* classid */
> >>    588  #endif
> >>    589                  + nla_total_size(sizeof(u_int32_t));    /* cap_len */
> >>    590  
> >>    591          tstamp = skb_tstamp_cond(entskb, false);
> >>    592          if (tstamp)
> >>    593                  size += nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
> >>    594  
> >>    595          size += nfqnl_get_bridge_size(entry);
> >>    596  
> >>    597          if (entry->state.hook <= NF_INET_FORWARD ||
> >>    598             (entry->state.hook == NF_INET_POST_ROUTING && entskb->sk == NULL))
> >>    599                  csum_verify = !skb_csum_unnecessary(entskb);
> >>    600          else
> >>    601                  csum_verify = false;
> >>    602  
> >>    603          outdev = entry->state.out;
> >>    604  
> >>    605          switch ((enum nfqnl_config_mode)READ_ONCE(queue->copy_mode)) {
> >>    606          case NFQNL_COPY_META:
> >>    607          case NFQNL_COPY_NONE:
> >>    608                  break;
> >>    609  
> >>    610          case NFQNL_COPY_PACKET:
> >>    611                  if (!(queue->flags & NFQA_CFG_F_GSO) &&
> >>    612                      entskb->ip_summed == CHECKSUM_PARTIAL &&
> >>    613                      nf_queue_checksum_help(entskb))
> >>    614                          return NULL;
> >>    615  
> >>    616                  data_len = READ_ONCE(queue->copy_range);
> >>    617                  if (data_len > entskb->len)
> >>    618                          data_len = entskb->len;
> >>    619  
> >>    620                  hlen = skb_zerocopy_headlen(entskb);
> >>    621                  hlen = min_t(unsigned int, hlen, data_len);
> >>    622                  size += sizeof(struct nlattr) + hlen;
> >>    623                  cap_len = entskb->len;
> >>    624                  break;
> >>    625          }
> >>    626  
> >>    627          nfnl_ct = rcu_dereference(nfnl_ct_hook);
> >>    628  
> >>    629  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> >>    630          if (queue->flags & NFQA_CFG_F_CONNTRACK) {
> >>    631                  if (nfnl_ct != NULL) {
> >>    632                          ct = nf_ct_get(entskb, &ctinfo);
> >>    633                          if (ct != NULL)
> >>    634                                  size += nfnl_ct->build_size(ct);
> >>    635                  }
> >>    636          }
> >>    637  #endif
> >>    638  
> >>    639          if (queue->flags & NFQA_CFG_F_UID_GID) {
> >>    640                  size += (nla_total_size(sizeof(u_int32_t))      /* uid */
> >>    641                          + nla_total_size(sizeof(u_int32_t)));   /* gid */
> >>    642          }
> >>    643  
> >>    644          if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> >>    645                  seclen = nfqnl_get_sk_secctx(entskb, &ctx);
> >>
> >> nfqnl_get_sk_secctx() returns negative error codes.  It needs to be changed ot
> >> int as well instead of u32.
> >>
> >>    646                  if (seclen >= 0)
> >>    647                          size += nla_total_size(seclen);
> >>    648          }
> >>    649  
> >>    650          skb = alloc_skb(size, GFP_ATOMIC);
> >>    651          if (!skb) {
> >>    652                  skb_tx_error(entskb);
> >>    653                  goto nlmsg_failure;
> >>    654          }
> >>    655  
> >>    656          nlh = nfnl_msg_put(skb, 0, 0,
> >>    657                             nfnl_msg_type(NFNL_SUBSYS_QUEUE, NFQNL_MSG_PACKET),
> >>    658                             0, entry->state.pf, NFNETLINK_V0,
> >>    659                             htons(queue->queue_num));
> >>    660          if (!nlh) {
> >>    661                  skb_tx_error(entskb);
> >>    662                  kfree_skb(skb);
> >>    663                  goto nlmsg_failure;
> >>    664          }
> >>    665  
> >>    666          nla = __nla_reserve(skb, NFQA_PACKET_HDR, sizeof(*pmsg));
> >>    667          pmsg = nla_data(nla);
> >>    668          pmsg->hw_protocol       = entskb->protocol;
> >>    669          pmsg->hook              = entry->state.hook;
> >>    670          *packet_id_ptr          = &pmsg->packet_id;
> >>    671  
> >>    672          indev = entry->state.in;
> >>    673          if (indev) {
> >>    674  #if !IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> >>    675                  if (nla_put_be32(skb, NFQA_IFINDEX_INDEV, htonl(indev->ifindex)))
> >>    676                          goto nla_put_failure;
> >>    677  #else
> >>    678                  if (entry->state.pf == PF_BRIDGE) {
> >>    679                          /* Case 1: indev is physical input device, we need to
> >>    680                           * look for bridge group (when called from
> >>    681                           * netfilter_bridge) */
> >>    682                          if (nla_put_be32(skb, NFQA_IFINDEX_PHYSINDEV,
> >>    683                                           htonl(indev->ifindex)) ||
> >>    684                          /* this is the bridge group "brX" */
> >>    685                          /* rcu_read_lock()ed by __nf_queue */
> >>    686                              nla_put_be32(skb, NFQA_IFINDEX_INDEV,
> >>    687                                           htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
> >>    688                                  goto nla_put_failure;
> >>    689                  } else {
> >>    690                          int physinif;
> >>    691  
> >>    692                          /* Case 2: indev is bridge group, we need to look for
> >>    693                           * physical device (when called from ipv4) */
> >>    694                          if (nla_put_be32(skb, NFQA_IFINDEX_INDEV,
> >>    695                                           htonl(indev->ifindex)))
> >>    696                                  goto nla_put_failure;
> >>    697  
> >>    698                          physinif = nf_bridge_get_physinif(entskb);
> >>    699                          if (physinif &&
> >>    700                              nla_put_be32(skb, NFQA_IFINDEX_PHYSINDEV,
> >>    701                                           htonl(physinif)))
> >>    702                                  goto nla_put_failure;
> >>    703                  }
> >>    704  #endif
> >>    705          }
> >>    706  
> >>    707          if (outdev) {
> >>    708  #if !IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> >>    709                  if (nla_put_be32(skb, NFQA_IFINDEX_OUTDEV, htonl(outdev->ifindex)))
> >>    710                          goto nla_put_failure;
> >>    711  #else
> >>    712                  if (entry->state.pf == PF_BRIDGE) {
> >>    713                          /* Case 1: outdev is physical output device, we need to
> >>    714                           * look for bridge group (when called from
> >>    715                           * netfilter_bridge) */
> >>    716                          if (nla_put_be32(skb, NFQA_IFINDEX_PHYSOUTDEV,
> >>    717                                           htonl(outdev->ifindex)) ||
> >>    718                          /* this is the bridge group "brX" */
> >>    719                          /* rcu_read_lock()ed by __nf_queue */
> >>    720                              nla_put_be32(skb, NFQA_IFINDEX_OUTDEV,
> >>    721                                           htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
> >>    722                                  goto nla_put_failure;
> >>    723                  } else {
> >>    724                          int physoutif;
> >>    725  
> >>    726                          /* Case 2: outdev is bridge group, we need to look for
> >>    727                           * physical output device (when called from ipv4) */
> >>    728                          if (nla_put_be32(skb, NFQA_IFINDEX_OUTDEV,
> >>    729                                           htonl(outdev->ifindex)))
> >>    730                                  goto nla_put_failure;
> >>    731  
> >>    732                          physoutif = nf_bridge_get_physoutif(entskb);
> >>    733                          if (physoutif &&
> >>    734                              nla_put_be32(skb, NFQA_IFINDEX_PHYSOUTDEV,
> >>    735                                           htonl(physoutif)))
> >>    736                                  goto nla_put_failure;
> >>    737                  }
> >>    738  #endif
> >>    739          }
> >>    740  
> >>    741          if (entskb->mark &&
> >>    742              nla_put_be32(skb, NFQA_MARK, htonl(entskb->mark)))
> >>    743                  goto nla_put_failure;
> >>    744  
> >>    745          if (entskb->priority &&
> >>    746              nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
> >>    747                  goto nla_put_failure;
> >>    748  
> >>    749          if (indev && entskb->dev &&
> >>    750              skb_mac_header_was_set(entskb) &&
> >>    751              skb_mac_header_len(entskb) != 0) {
> >>    752                  struct nfqnl_msg_packet_hw phw;
> >>    753                  int len;
> >>    754  
> >>    755                  memset(&phw, 0, sizeof(phw));
> >>    756                  len = dev_parse_header(entskb, phw.hw_addr);
> >>    757                  if (len) {
> >>    758                          phw.hw_addrlen = htons(len);
> >>    759                          if (nla_put(skb, NFQA_HWADDR, sizeof(phw), &phw))
> >>    760                                  goto nla_put_failure;
> >>    761                  }
> >>    762          }
> >>    763  
> >>    764          if (nfqnl_put_bridge(entry, skb) < 0)
> >>    765                  goto nla_put_failure;
> >>    766  
> >>    767          if (entry->state.hook <= NF_INET_FORWARD && tstamp) {
> >>    768                  struct nfqnl_msg_packet_timestamp ts;
> >>    769                  struct timespec64 kts = ktime_to_timespec64(tstamp);
> >>    770  
> >>    771                  ts.sec = cpu_to_be64(kts.tv_sec);
> >>    772                  ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
> >>    773  
> >>    774                  if (nla_put(skb, NFQA_TIMESTAMP, sizeof(ts), &ts))
> >>    775                          goto nla_put_failure;
> >>    776          }
> >>    777  
> >>    778          if ((queue->flags & NFQA_CFG_F_UID_GID) && entskb->sk &&
> >>    779              nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
> >>    780                  goto nla_put_failure;
> >>    781  
> >>    782          if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
> >>    783                  goto nla_put_failure;
> >>    784  
> >>    785          if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
> >>                     ^^^^^^
> >> This doesn't look right.
> >>
> >>
> >>    786                  goto nla_put_failure;
> >>    787  
> >>    788          if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
> >>    789                  goto nla_put_failure;
> >>    790  
> >>    791          if (cap_len > data_len &&
> >>    792              nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
> >>    793                  goto nla_put_failure;
> >>    794  
> >>    795          if (nfqnl_put_packet_info(skb, entskb, csum_verify))
> >>    796                  goto nla_put_failure;
> >>    797  
> >>    798          if (data_len) {
> >>    799                  struct nlattr *nla;
> >>    800  
> >>    801                  if (skb_tailroom(skb) < sizeof(*nla) + hlen)
> >>    802                          goto nla_put_failure;
> >>    803  
> >>    804                  nla = skb_put(skb, sizeof(*nla));
> >>    805                  nla->nla_type = NFQA_PAYLOAD;
> >>    806                  nla->nla_len = nla_attr_size(data_len);
> >>    807  
> >>    808                  if (skb_zerocopy(skb, entskb, data_len, hlen))
> >>    809                          goto nla_put_failure;
> >>    810          }
> >>    811  
> >>    812          nlh->nlmsg_len = skb->len;
> >>    813          if (seclen >= 0)
> >>                     ^^^^^^^^^^^
> >>
> >>    814                  security_release_secctx(&ctx);
> >>    815          return skb;
> >>    816  
> >>    817  nla_put_failure:
> >>    818          skb_tx_error(entskb);
> >>    819          kfree_skb(skb);
> >>    820          net_err_ratelimited("nf_queue: error creating packet message\n");
> >>    821  nlmsg_failure:
> >>    822          if (seclen >= 0)
> >>                     ^^^^^^^^^^^
> >>
> >>    823                  security_release_secctx(&ctx);
> >>    824          return NULL;
> >>    825  }
> >>
> >>
> >>
> >> regards,
> >> dan carpenter
> >>
