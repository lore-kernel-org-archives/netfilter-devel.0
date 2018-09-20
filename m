From: =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: Re: [PATCH] netfilter: nf_tables: add SECMARK support
Date: Thu, 20 Sep 2018 09:18:56 +0200
Message-ID: <CAJ2a_Ddd19txwUiKkOwpdWUSq9+VWFSR6Cqe4zgXKggWUPi4hw@mail.gmail.com>
References: <20180919231402.4482-1-cgzones@googlemail.com> <75b3fed9-e549-4ed0-c435-ec4795fc1e39@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, jmorris@namei.org,
        serge@hallyn.com, selinux <selinux@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org
To: casey@schaufler-ca.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <75b3fed9-e549-4ed0-c435-ec4795fc1e39@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> I've only had a cursory look at your patch, but how is it
> different from what's in xt_SECMARK.c ?

xt_SEXMARK.c is for xtables, use-able in iptables; this is for nftables (nft)
