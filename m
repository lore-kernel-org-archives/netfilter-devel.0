From: dann frazier <dannf@hp.com>
Subject: Bug#336431: [PATCH] fix ip_conntrack_helper_pptp build when CONFIG_IP_NF_NAT_NEEDED=n
Date: Thu, 03 Nov 2005 09:29:53 -0700
Message-ID: <1131035393.6600.118.camel@localhost>
References: <1130807635.6630.13.camel@localhost>
	 <20051103095409.GY4479@sunbeam.de.gnumonks.org>
Reply-To: dann frazier <dannf@hp.com>, 336431@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: control@bugs.debian.org, netfilter-devel@lists.netfilter.org,
	336431@bugs.debian.org
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.336431.B336431.113103550923716@bugs.debian.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051103095409.GY4479@sunbeam.de.gnumonks.org>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

tags 336431 + upstream
tags 336431 + patch
stop

On Thu, 2005-11-03 at 10:54 +0100, Harald Welte wrote:
> On Mon, Oct 31, 2005 at 06:13:55PM -0700, dann frazier wrote:
> > As reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=336431,
> > ip_conntrack_helper_pptp in 2.6.14 fails to build if
> > CONFIG_IP_NF_NAT_NEEDED isn't enabled.  This patch fixes this by
> > disabling manipulation of the dir field of ip_conntrack_expect
> > structures when full nat isn't configured.  Compile tested only.
> 
> Thanks for reporting this bug.   Yasuyuki Kozakai has submitted a
> slightly cleaner version, so I'm merging his patch.

Thanks for the response Harald.

Looks like this is the patch we should use:
  http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=2991

-- 
dann frazier <dannf@hp.com>
