From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd2 PATCH 2/4] Use stdint types everywhere
Date: Tue, 23 Jun 2015 14:37:37 +0200
Message-ID: <1435063057.4241.5.camel@regit.org>
References: <20150516130207.GC14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Felix Janda <felix.janda@posteo.de>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37239 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbbFWNCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2015 09:02:43 -0400
In-Reply-To: <20150516130207.GC14201@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Hello Felix,

Sorry for the delay in the answer.

Other patches of the series are ok, comments on this one inline.

On Sat, 2015-05-16 at 15:02 +0200, Felix Janda wrote:
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  filter/raw2packet/ulogd_raw2packet_BASE.c | 42 +++++++++++++++------
> ----------
>  filter/ulogd_filter_HWHDR.c               |  6 ++---
>  filter/ulogd_filter_IP2HBIN.c             |  4 +--
>  filter/ulogd_filter_IP2STR.c              |  2 +-
>  filter/ulogd_filter_MARK.c                |  4 +--
>  filter/ulogd_filter_PWSNIFF.c             |  4 +--
>  include/libipulog/libipulog.h             |  4 +--
>  include/ulogd/addr.h                      |  2 +-
>  include/ulogd/conffile.h                  |  8 +++---
>  include/ulogd/ipfix_protocol.h            | 36 +++++++++++++--------
> -----
>  include/ulogd/ulogd.h                     | 42 +++++++++++++++------
> ----------
>  input/packet/ulogd_inppkt_NFLOG.c         | 16 ++++++------
>  input/packet/ulogd_inppkt_UNIXSOCK.c      | 34 ++++++++++++---------
> ----
>  libipulog/libipulog.c                     |  8 +++---
>  output/mysql/ulogd_output_MYSQL.c         |  2 +-
>  output/ulogd_output_IPFIX.c               | 20 +++++++--------
>  src/addr.c                                |  4 +--
>  util/db.c                                 |  2 +-
>  util/printpkt.c                           |  6 ++---
>  19 files changed, 123 insertions(+), 123 deletions(-)


I'm ok with the idea of the patch but this is not building anymore on
my Debian.

|| make[2]: Entering directory
'/home/eric/git/netfilter/ulogd2/libipulog'
||   CC       libipulog.lo
include/libipulog/libipulog.h|23 col 1| error: unknown type name
'uint32_t'
||  uint32_t ipulog_group2gmask(uint32_t group);
||  ^
include/libipulog/libipulog.h|23 col 29| error: unknown type name
'uint32_t'
||  uint32_t ipulog_group2gmask(uint32_t group);
||                              ^
int32_t group);
||                              ^


I've got plenty of similar error.

Could you fix this an resubmit ?

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

