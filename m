From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Add arptables mangle module
Date: Wed, 25 Jun 2003 23:25:43 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030625.232543.15267360.davem@redhat.com>
References: <200306260816.49221.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bdschuym@pandora.be
In-Reply-To: <200306260816.49221.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Bart De Schuymer <bdschuym@pandora.be>
   Date: Thu, 26 Jun 2003 08:16:49 +0200

   Note that the only publicly available arptables userspace tool that
   I know of is the one in my CVS, so there's no major risk of
   breaking anything.

I know that people have crafted their own private tools in
order to use vanilla 2.4.x with certain IPVS configurations.

I don't think they'll be too happy if you change the API,
at leas tin 2.4.x, for that reason.

   The module could also be useful in 2.4, I'll make a patch if you
   want it in 2.4.

I agree, please do.
