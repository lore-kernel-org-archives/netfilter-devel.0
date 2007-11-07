From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 8 Nov 2007 00:08:52 +0100
Message-ID: <20071107230852.GA3206@eychenne.org>
References: <47322D4A.3090201@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:24603 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbXKGXIn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:08:43 -0500
Content-Disposition: inline
In-Reply-To: <47322D4A.3090201@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 07, 2007 at 10:25:30PM +0100, Peter Warasin wrote:

 Hi,

> The following patch renames the option --test (-t) to --dry-run (-d)
> in order to free the letter 't' for --table, which makes the options
> more consistent regarding the other *tables tools, where -t is always
> --table.

Well, a long time ago (more than 3 years, a few days before the 2004
workshop), I had sent a big patch which contained among others things:
- the ability to restore only one table
- a better(?) testing mode

This patch was juged too big (72 KB) and it was not applied:
I admit I should have broken it up into many smaller patches, but the
amount of work was somewhat discouraging.
Well, I'm glad some of these ideas have been resurfacing in (smaller)
pieces over time.

Here are some thoughts (dating from this time) related to testing
mode:

- the -d option is generally used (as a debug switch). The one-letter
  equivalent of --dry-run is generally -n.

- I had taken a different approach than the existing one for "testing
  mode". I think I can recall having encountered some problems
  with the current approach, but I cannot remember which ones exactly
  after all this time.
  Anyway, I ended up implementing testing mode at the libiptc level,
  which is better as it is more generic and enables to validate iptable=
s
  command line (and not only iptables-restore file) syntax as well.

I wish I had the courage and the time to go through my old big patch
and extract the things that are still relevant today.
I had asked at that time to this list if someone knew a patch splitter
GUI, that would enable to split a patch into several (sub)patches by
graphically selecting which changes would go to each (sub)patch.
Maybe there has been some progress on this, or some new well-informed
readers?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)  Homepage:          http://www.eychenne.org/
v_/_ WallFire project:  http://www.wallfire.org/
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
