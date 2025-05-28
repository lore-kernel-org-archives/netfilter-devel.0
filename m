Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29674685
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 23:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748475835; cv=none; b=UZa/bI8KnVg9qjVxlmDGtj+uXKS1o58SiytwZ8QmxyQniyhdL0zHM/28lodOuUqMDJv5FglZv/usb6lQLSUJFRXyp12gha1klsnwFGAOI7eovbNRZxF4xlOE8YuJlI/wvKQDSkUh8op8znSmrrv+rlV5X/+lgKjKlZGkJYZiTqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748475835; c=relaxed/simple;
	bh=TP8UGFWikOSxlKPd0jLn84b623GTqEhVSJcXKtl2neE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HybScKJkkSfzYMvEcuioSB4vhB91+T+7ADV1UbnZ308YxMEP/e5ZfcYPb09EgBjDDWf6eyeBU9HQA1mYzQ2zbEB/4kY0k3vePg7m3ztcNgVfOIbbihp9EwbzLo9PWvC7/wxnxZeuKHHHU9JTlJ+uSxtuVVQ7HR2ZZf0qGBY7Y6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Asj/bsG2; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Asj/bsG2"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4766631a6a4so3815151cf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748475833; x=1749080633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLvoJblHFSIohYuMZl/LwdFZJn1fxFWBBN213Sly7sg=;
        b=Asj/bsG2+4AKSInwkckTbA/P9iE5JL5xLEwOLBeBAjIGeM22Ha5khyI87AhsQV8cGY
         LEOSvWNSlDJMghSV6j/vhnVoB14HMD986acTp4ySWJSLANFo94WuBJSEMmyX/qBux81r
         szWrl0pVI4u1lbCWQT4wV0AAH00BEwygR/Kpv/vBvnHuRbziZNO1zeHxjytfPevxWqQA
         BHqzAU4DUrL6FHyrl2XY4GQVVhEYeYqgzBos8ZarlRa4dn0ZKyoluRBbeBzdXKIWCPIR
         MG9p/P3EdYlKcFSkSGzkzqa2+pf7OHVRSf+oPJIjzEGU3n+C7g6hAcNwOxzbehMYGtJm
         rmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748475833; x=1749080633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLvoJblHFSIohYuMZl/LwdFZJn1fxFWBBN213Sly7sg=;
        b=muFaS+9+CuX8/S2HkGqnk57+3ortc5k186gn+aGkmHGTPoilecZDaJkDBkg0fA1dA0
         asNsmCeUsJAVpFCRfX8eiOqohVP8G6OAqf0JgOVjM7+rdKwu56f54kypf2EgpTWugvEt
         DPmw1/LYpFVx/Zw77hHDFxCWm38qnK0ohjLfH1JCA1+xH0+Qymih1iCxLzjoYiNPVqYH
         BQSK82L9dLjHVkDtSxKE0n9Ve+kWk/rsIwtYp4cI5l7q+jn0sgkgPO8NpcQvNKr5YH1O
         U8mpDN06HXiTcW8FPhqYWCPa3pf4Euy+23CmfPRneMS9tEuo2nW+JNhwUtDPD8s+Wlay
         tKQw==
X-Forwarded-Encrypted: i=1; AJvYcCVgkdjJW8S1H29aoO6Uxu5Nl/Ra8U3rbATN6u9gQWxxQ09wcb7g6YuKKfvzKYv5zDzk2h1ZwaX81uMosOBCjHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2vUozsf2uIUWH897Z2iTKjiimjRql5NvclweYK0Esa1Vrx4wn
	3t3UFx/EXlBn7/9OZUj4zrkgFThkRiJjZm5ut+OgBaMKUSgnjoN/KYjv
X-Gm-Gg: ASbGncsEGHodPycYX2/EQdCGcbg+rISivL9zKOsd6EduA7XwriBcg/9VwxXWUVxs2cC
	C+t/oJPZT18DpYvlBTI8vWtugz0CunH5NVH2thKahJw3ZbVFBU3MY/vDqjhlz7eWrk6F2kdIsAb
	D6KhbAd5LH6ZPR4/CYXXMGYXiTsXDO+iIK6Rn/chxNcb3e8nMskLgpBRQbCWstIwAPlh7l/KVWM
	RDeonzfrZQxFhF44cDkeirtW6cH/h2fJbvKKfJEiqakfO064oRUrtDCipq22VKbnOsom321jnN3
	joV+KiiIf+7esIGmts9kc9VGSOcosMV1vrddEtt7zqIhnP/7h54rZ6HVYLxhgQOYVqTkYXBGjJ6
	oA1jI3AV1
X-Google-Smtp-Source: AGHT+IGEMGQSSfmbwfKF205v/VBHSDfg9V6bcLfSkWdvIGTeNKbA0aXIWpQNJzVi1e1nR/QI2wfb2A==
X-Received: by 2002:a05:622a:c87:b0:48e:1f6c:227b with SMTP id d75a77b69052e-49f46e306ddmr335608011cf.26.1748475832679;
        Wed, 28 May 2025 16:43:52 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a435772abcsm1217711cf.5.2025.05.28.16.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 16:43:52 -0700 (PDT)
Date: Wed, 28 May 2025 19:43:50 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDeftvfuOufo5kdw@fedora>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>

On Wed, May 28, 2025 at 05:03:56PM +0800, Yafang Shao wrote:
> diff --git a/net/netfilter/nf_conntrack_core.c
> b/net/netfilter/nf_conntrack_core.c
> index 7bee5bd22be2..3481e9d333b0 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> 
>         chainlen = 0;
>         hlist_nulls_for_each_entry(h, n,
> &nf_conntrack_hash[reply_hash], hnnode) {
> -               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> -                                   zone, net))
> -                       goto out;
> +               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> +               //                  zone, net))
> +               //      goto out;
>                 if (chainlen++ > max_chainlen) {
>  chaintoolong:
>                         NF_CT_STAT_INC(net, chaintoolong);

Forgive me for jumping in with very little information, but on a hunch I
tried something.  I applied the above patch to another bug I've been
investigating:

https://bugzilla.netfilter.org/show_bug.cgi?id=1795
and Ubuntu reference
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2109889

The Ubuntu reproduction steps where easier to follow, so I mimicked
them:

# cat add_ip.sh 
ip addr add 10.0.1.200/24 dev enp1s0
# cat nft.sh 
nft -f - <<EOF
table ip dnat-test {
 chain prerouting {
  type nat hook prerouting priority dstnat; policy accept;
  ip daddr 10.0.1.200 udp dport 1234 counter dnat to 10.0.1.180:1234
 }
}
EOF
# cat listen.sh 
echo pong|nc -l -u 10.0.1.180 1234
# ./add_ip.sh ; ./nft.sh ; listen.sh (and then just ./listen.sh again)

On a client machine I ran:
$ echo ping|nc -u -p 4321 10.0.1.200 1234
$ echo ping|nc -u -p 4321 10.0.1.180 1234

And sure enough the listen.sh never completes (demonstrates the bug).

When I apply the above patch, the problem goes away.

What I _also_ was able to do to make the problem go away was to apply
the following patch:

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index aad84aabd7f1..fecf5591f424 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -727,7 +727,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
            !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
                /* try the original tuple first */
                if (nf_in_range(orig_tuple, range)) {
-                       if (!nf_nat_used_tuple_new(orig_tuple, ct)) {
+                       if (!nf_nat_used_tuple(orig_tuple, ct)) {
                                *tuple = *orig_tuple;
                                return;
                        }

This was suggested to me by the bug report.  I had not brought this up
yet, as I had little understanding of why and what else was broken by
reverting to nf_nat_used_tuple from _new.

I thought that both patches fix the problem might be of interest.  I'll
keep digging in to my understanding.....



SB
