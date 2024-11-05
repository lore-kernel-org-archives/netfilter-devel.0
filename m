Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7191D358D;
	Tue,  5 Nov 2024 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730805170; cv=none; b=BT3gIwUsgEyy3GmPQb6k0n0YmbNZ9z2mX8dT/x1TpwjIffTCsghiLjEBsJTblNxPrRbCCz0QBsGP811ZeAXfELoNDdKkF6TzsXUTCPa9/9OKsscx4m5slyki56KGCtFkNW1mHzRYYo8a+ZyOh60fuW4wxWMwGNp5aohNDMAQLJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730805170; c=relaxed/simple;
	bh=7nNATPDEBg3OK1LEPP1dcczkbM6qHSfnP/BKDbrvhuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXxHp0x+NyMJn7wQVsfUpc0IPgDRJ00lLc01+oeWOoV/sUhHmwkak0xbOPl38RujyzPJKORmu6F6Y0GjbIWZJTI3aJmbfJKPePxi31ab6fGzh1JBeKKwcLE4w68KaXl/Bjvl9PVgCsCLhCDCprCbUS/Ni/9XMp7j9BML6JeZ+D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39816 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8HUA-004LHX-Ip; Tue, 05 Nov 2024 12:12:36 +0100
Date: Tue, 5 Nov 2024 12:12:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [bug report] lsm: replace context+len with lsm_context
Message-ID: <Zyn9oJ9oxltqbK0x@calendula>
References: <549fd50d-a631-4103-bfe2-e842de387163@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <549fd50d-a631-4103-bfe2-e842de387163@stanley.mountain>
X-Spam-Score: -1.6 (-)

Hi,

There is another issue in this recent series, see below.

This needs another follow up.

Thanks.

On Sat, Nov 02, 2024 at 12:21:01PM +0300, Dan Carpenter wrote:
> Hello Casey Schaufler,
> 
> Commit 95a3c11eb670 ("lsm: replace context+len with lsm_context")
> from Oct 23, 2024 (linux-next), leads to the following Smatch static
> checker warning:
> 
>   net/netfilter/nfnetlink_queue.c:646 nfqnl_build_packet_message()
>   warn: always true condition '(seclen >= 0) => (0-u32max >= 0)'
> 
>   net/netfilter/nfnetlink_queue.c:813 nfqnl_build_packet_message()
>   warn: always true condition '(seclen >= 0) => (0-u32max >= 0)'
> 
>   net/netfilter/nfnetlink_queue.c:822 nfqnl_build_packet_message()
>   warn: always true condition '(seclen >= 0) => (0-u32max >= 0)'
> 
> net/netfilter/nfnetlink_queue.c
>    551  static struct sk_buff *
>    552  nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>    553                             struct nf_queue_entry *entry,
>    554                             __be32 **packet_id_ptr)
>    555  {
>    556          size_t size;
>    557          size_t data_len = 0, cap_len = 0;
>    558          unsigned int hlen = 0;
>    559          struct sk_buff *skb;
>    560          struct nlattr *nla;
>    561          struct nfqnl_msg_packet_hdr *pmsg;
>    562          struct nlmsghdr *nlh;
>    563          struct sk_buff *entskb = entry->skb;
>    564          struct net_device *indev;
>    565          struct net_device *outdev;
>    566          struct nf_conn *ct = NULL;
>    567          enum ip_conntrack_info ctinfo = 0;
>    568          const struct nfnl_ct_hook *nfnl_ct;
>    569          bool csum_verify;
>    570          struct lsm_context ctx;
>    571          u32 seclen = 0;
>                 ^^^^^^^^^^
> 
>    572          ktime_t tstamp;
>    573  
>    574          size = nlmsg_total_size(sizeof(struct nfgenmsg))
>    575                  + nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
>    576                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
>    577                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
>    578  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>    579                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
>    580                  + nla_total_size(sizeof(u_int32_t))     /* ifindex */
>    581  #endif
>    582                  + nla_total_size(sizeof(u_int32_t))     /* mark */
>    583                  + nla_total_size(sizeof(u_int32_t))     /* priority */
>    584                  + nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
>    585                  + nla_total_size(sizeof(u_int32_t))     /* skbinfo */
>    586  #if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
>    587                  + nla_total_size(sizeof(u_int32_t))     /* classid */
>    588  #endif
>    589                  + nla_total_size(sizeof(u_int32_t));    /* cap_len */
>    590  
>    591          tstamp = skb_tstamp_cond(entskb, false);
>    592          if (tstamp)
>    593                  size += nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
>    594  
>    595          size += nfqnl_get_bridge_size(entry);
>    596  
>    597          if (entry->state.hook <= NF_INET_FORWARD ||
>    598             (entry->state.hook == NF_INET_POST_ROUTING && entskb->sk == NULL))
>    599                  csum_verify = !skb_csum_unnecessary(entskb);
>    600          else
>    601                  csum_verify = false;
>    602  
>    603          outdev = entry->state.out;
>    604  
>    605          switch ((enum nfqnl_config_mode)READ_ONCE(queue->copy_mode)) {
>    606          case NFQNL_COPY_META:
>    607          case NFQNL_COPY_NONE:
>    608                  break;
>    609  
>    610          case NFQNL_COPY_PACKET:
>    611                  if (!(queue->flags & NFQA_CFG_F_GSO) &&
>    612                      entskb->ip_summed == CHECKSUM_PARTIAL &&
>    613                      nf_queue_checksum_help(entskb))
>    614                          return NULL;
>    615  
>    616                  data_len = READ_ONCE(queue->copy_range);
>    617                  if (data_len > entskb->len)
>    618                          data_len = entskb->len;
>    619  
>    620                  hlen = skb_zerocopy_headlen(entskb);
>    621                  hlen = min_t(unsigned int, hlen, data_len);
>    622                  size += sizeof(struct nlattr) + hlen;
>    623                  cap_len = entskb->len;
>    624                  break;
>    625          }
>    626  
>    627          nfnl_ct = rcu_dereference(nfnl_ct_hook);
>    628  
>    629  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>    630          if (queue->flags & NFQA_CFG_F_CONNTRACK) {
>    631                  if (nfnl_ct != NULL) {
>    632                          ct = nf_ct_get(entskb, &ctinfo);
>    633                          if (ct != NULL)
>    634                                  size += nfnl_ct->build_size(ct);
>    635                  }
>    636          }
>    637  #endif
>    638  
>    639          if (queue->flags & NFQA_CFG_F_UID_GID) {
>    640                  size += (nla_total_size(sizeof(u_int32_t))      /* uid */
>    641                          + nla_total_size(sizeof(u_int32_t)));   /* gid */
>    642          }
>    643  
>    644          if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
>    645                  seclen = nfqnl_get_sk_secctx(entskb, &ctx);
> 
> nfqnl_get_sk_secctx() returns negative error codes.  It needs to be changed ot
> int as well instead of u32.
> 
>    646                  if (seclen >= 0)
>    647                          size += nla_total_size(seclen);
>    648          }
>    649  
>    650          skb = alloc_skb(size, GFP_ATOMIC);
>    651          if (!skb) {
>    652                  skb_tx_error(entskb);
>    653                  goto nlmsg_failure;
>    654          }
>    655  
>    656          nlh = nfnl_msg_put(skb, 0, 0,
>    657                             nfnl_msg_type(NFNL_SUBSYS_QUEUE, NFQNL_MSG_PACKET),
>    658                             0, entry->state.pf, NFNETLINK_V0,
>    659                             htons(queue->queue_num));
>    660          if (!nlh) {
>    661                  skb_tx_error(entskb);
>    662                  kfree_skb(skb);
>    663                  goto nlmsg_failure;
>    664          }
>    665  
>    666          nla = __nla_reserve(skb, NFQA_PACKET_HDR, sizeof(*pmsg));
>    667          pmsg = nla_data(nla);
>    668          pmsg->hw_protocol       = entskb->protocol;
>    669          pmsg->hook              = entry->state.hook;
>    670          *packet_id_ptr          = &pmsg->packet_id;
>    671  
>    672          indev = entry->state.in;
>    673          if (indev) {
>    674  #if !IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>    675                  if (nla_put_be32(skb, NFQA_IFINDEX_INDEV, htonl(indev->ifindex)))
>    676                          goto nla_put_failure;
>    677  #else
>    678                  if (entry->state.pf == PF_BRIDGE) {
>    679                          /* Case 1: indev is physical input device, we need to
>    680                           * look for bridge group (when called from
>    681                           * netfilter_bridge) */
>    682                          if (nla_put_be32(skb, NFQA_IFINDEX_PHYSINDEV,
>    683                                           htonl(indev->ifindex)) ||
>    684                          /* this is the bridge group "brX" */
>    685                          /* rcu_read_lock()ed by __nf_queue */
>    686                              nla_put_be32(skb, NFQA_IFINDEX_INDEV,
>    687                                           htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
>    688                                  goto nla_put_failure;
>    689                  } else {
>    690                          int physinif;
>    691  
>    692                          /* Case 2: indev is bridge group, we need to look for
>    693                           * physical device (when called from ipv4) */
>    694                          if (nla_put_be32(skb, NFQA_IFINDEX_INDEV,
>    695                                           htonl(indev->ifindex)))
>    696                                  goto nla_put_failure;
>    697  
>    698                          physinif = nf_bridge_get_physinif(entskb);
>    699                          if (physinif &&
>    700                              nla_put_be32(skb, NFQA_IFINDEX_PHYSINDEV,
>    701                                           htonl(physinif)))
>    702                                  goto nla_put_failure;
>    703                  }
>    704  #endif
>    705          }
>    706  
>    707          if (outdev) {
>    708  #if !IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>    709                  if (nla_put_be32(skb, NFQA_IFINDEX_OUTDEV, htonl(outdev->ifindex)))
>    710                          goto nla_put_failure;
>    711  #else
>    712                  if (entry->state.pf == PF_BRIDGE) {
>    713                          /* Case 1: outdev is physical output device, we need to
>    714                           * look for bridge group (when called from
>    715                           * netfilter_bridge) */
>    716                          if (nla_put_be32(skb, NFQA_IFINDEX_PHYSOUTDEV,
>    717                                           htonl(outdev->ifindex)) ||
>    718                          /* this is the bridge group "brX" */
>    719                          /* rcu_read_lock()ed by __nf_queue */
>    720                              nla_put_be32(skb, NFQA_IFINDEX_OUTDEV,
>    721                                           htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
>    722                                  goto nla_put_failure;
>    723                  } else {
>    724                          int physoutif;
>    725  
>    726                          /* Case 2: outdev is bridge group, we need to look for
>    727                           * physical output device (when called from ipv4) */
>    728                          if (nla_put_be32(skb, NFQA_IFINDEX_OUTDEV,
>    729                                           htonl(outdev->ifindex)))
>    730                                  goto nla_put_failure;
>    731  
>    732                          physoutif = nf_bridge_get_physoutif(entskb);
>    733                          if (physoutif &&
>    734                              nla_put_be32(skb, NFQA_IFINDEX_PHYSOUTDEV,
>    735                                           htonl(physoutif)))
>    736                                  goto nla_put_failure;
>    737                  }
>    738  #endif
>    739          }
>    740  
>    741          if (entskb->mark &&
>    742              nla_put_be32(skb, NFQA_MARK, htonl(entskb->mark)))
>    743                  goto nla_put_failure;
>    744  
>    745          if (entskb->priority &&
>    746              nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
>    747                  goto nla_put_failure;
>    748  
>    749          if (indev && entskb->dev &&
>    750              skb_mac_header_was_set(entskb) &&
>    751              skb_mac_header_len(entskb) != 0) {
>    752                  struct nfqnl_msg_packet_hw phw;
>    753                  int len;
>    754  
>    755                  memset(&phw, 0, sizeof(phw));
>    756                  len = dev_parse_header(entskb, phw.hw_addr);
>    757                  if (len) {
>    758                          phw.hw_addrlen = htons(len);
>    759                          if (nla_put(skb, NFQA_HWADDR, sizeof(phw), &phw))
>    760                                  goto nla_put_failure;
>    761                  }
>    762          }
>    763  
>    764          if (nfqnl_put_bridge(entry, skb) < 0)
>    765                  goto nla_put_failure;
>    766  
>    767          if (entry->state.hook <= NF_INET_FORWARD && tstamp) {
>    768                  struct nfqnl_msg_packet_timestamp ts;
>    769                  struct timespec64 kts = ktime_to_timespec64(tstamp);
>    770  
>    771                  ts.sec = cpu_to_be64(kts.tv_sec);
>    772                  ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
>    773  
>    774                  if (nla_put(skb, NFQA_TIMESTAMP, sizeof(ts), &ts))
>    775                          goto nla_put_failure;
>    776          }
>    777  
>    778          if ((queue->flags & NFQA_CFG_F_UID_GID) && entskb->sk &&
>    779              nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
>    780                  goto nla_put_failure;
>    781  
>    782          if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
>    783                  goto nla_put_failure;
>    784  
>    785          if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
>                     ^^^^^^
> This doesn't look right.
> 
> 
>    786                  goto nla_put_failure;
>    787  
>    788          if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
>    789                  goto nla_put_failure;
>    790  
>    791          if (cap_len > data_len &&
>    792              nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
>    793                  goto nla_put_failure;
>    794  
>    795          if (nfqnl_put_packet_info(skb, entskb, csum_verify))
>    796                  goto nla_put_failure;
>    797  
>    798          if (data_len) {
>    799                  struct nlattr *nla;
>    800  
>    801                  if (skb_tailroom(skb) < sizeof(*nla) + hlen)
>    802                          goto nla_put_failure;
>    803  
>    804                  nla = skb_put(skb, sizeof(*nla));
>    805                  nla->nla_type = NFQA_PAYLOAD;
>    806                  nla->nla_len = nla_attr_size(data_len);
>    807  
>    808                  if (skb_zerocopy(skb, entskb, data_len, hlen))
>    809                          goto nla_put_failure;
>    810          }
>    811  
>    812          nlh->nlmsg_len = skb->len;
>    813          if (seclen >= 0)
>                     ^^^^^^^^^^^
> 
>    814                  security_release_secctx(&ctx);
>    815          return skb;
>    816  
>    817  nla_put_failure:
>    818          skb_tx_error(entskb);
>    819          kfree_skb(skb);
>    820          net_err_ratelimited("nf_queue: error creating packet message\n");
>    821  nlmsg_failure:
>    822          if (seclen >= 0)
>                     ^^^^^^^^^^^
> 
>    823                  security_release_secctx(&ctx);
>    824          return NULL;
>    825  }
> 
> 
> 
> regards,
> dan carpenter
> 
