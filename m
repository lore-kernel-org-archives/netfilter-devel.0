Return-Path: <SRS0=cUbz=XJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B90C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Sep 2019 03:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269E320644
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Sep 2019 03:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfIND0R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 23:26:17 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47897 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731271AbfIND0R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 23:26:17 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 803C6361A60
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Sep 2019 13:25:58 +1000 (AEST)
Received: (qmail 15550 invoked by uid 501); 14 Sep 2019 03:25:56 -0000
Date:   Sat, 14 Sep 2019 13:25:56 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] src: Enable doxygen to generate Function Documentation
Message-ID: <20190914032556.GA14997@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20190908082505.3320-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908082505.3320-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=PO7r1zJSAAAA:8 a=mQtVz7DCHv6ROT31A6kA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Sep 08, 2019 at 06:25:05PM +1000, Duncan Roe wrote:
> The C source files all contain doxygen documentation for each defined function
> but this was not appearing in the generated HTML.
> Fix is to move all EXPORT_SYMBOL macro calls to after the function definition.
> Doxygen seems to otherwise forget the documentation on encountering
> EXPORT_SYMBOL which is flagged in the EXCLUDE_SYMBOLS tag in doxygen.cfg.in.
> I encountered this "feature" in doxygen 1.8.9.1 but it still appears to be
> present in 1.8.16
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/attr.c     | 70 +++++++++++++++++++++++++++++-----------------------------
>  src/callback.c |  4 ++--
>  src/nlmsg.c    | 40 ++++++++++++++++-----------------
>  src/socket.c   | 22 +++++++++---------
>  4 files changed, 68 insertions(+), 68 deletions(-)
>
> diff --git a/src/attr.c b/src/attr.c
> index 0359ba9..ca42d3e 100644
> --- a/src/attr.c
> +++ b/src/attr.c
> @@ -35,11 +35,11 @@
>   *
>   * This function returns the attribute type.
>   */
> -EXPORT_SYMBOL(mnl_attr_get_type);
>  uint16_t mnl_attr_get_type(const struct nlattr *attr)
>  {
>  	return attr->nla_type & NLA_TYPE_MASK;
>  }
> +EXPORT_SYMBOL(mnl_attr_get_type);
>
[...]

Oops! I forgot to say: this is a patch for libmnl.

Cheers ... Duncan.
