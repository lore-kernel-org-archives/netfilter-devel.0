From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 1/2] netfilter: nf_tables: add SECMARK support
Date: Fri, 28 Sep 2018 11:01:11 +0200
Message-ID: <20180928090111.7h2rj5vbf5l2dzcy@salvia>
References: <20180923182616.11398-1-cgzones@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        jmorris@namei.org, serge@hallyn.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
To: Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180923182616.11398-1-cgzones@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Sep 23, 2018 at 08:26:15PM +0200, Christian Göttsche wrote:
> Add the ability to set the security context of packets within the nf_tables framework.
> Add a nft_object for holding security contexts in the kernel and manipulating packets on the wire.
> 
> Convert the security context strings at rule addition time to security identifiers.
> This is the same behavior like in xt_SECMARK and offers better performance than computing it per packet.
> 
> Set the maximum security context length to 256.

Applied, thanks Christian.
