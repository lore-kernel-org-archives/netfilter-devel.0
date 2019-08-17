Return-Path: <SRS0=n2xU=WN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96AAC3A59D
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 01:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3260205F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 01:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfHQB1i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 21:27:38 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40719 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbfHQB1i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 21:27:38 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 21:27:35 EDT
Received: from dimstar.local.net (unknown [114.72.91.7])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id B7B60361C5E
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2019 11:04:56 +1000 (AEST)
Received: (qmail 26837 invoked by uid 501); 17 Aug 2019 01:04:51 -0000
Date:   Sat, 17 Aug 2019 11:04:51 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] src: fix strncpy -Wstringop-truncation
 warnings
Message-ID: <20190817010451.GA4911@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org
References: <20190816092511.830-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816092511.830-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=j7Z9DUGHOYSlcI8coM27+w==:117 a=j7Z9DUGHOYSlcI8coM27+w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=bBqXziUQAAAA:8 a=higmGc5uha10EgAAnhcA:9 a=BE1EReVqkM0DrJgs:21
        a=iLd4QAoMwaXBxHLJ:21 a=CjuIK1q_8ugA:10 a=BjKv_IHbNJvPKzgot4uq:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jose,

PLEASE DO NOT DO THIS! See at end

On Fri, Aug 16, 2019 at 11:25:11AM +0200, Jose M. Guisado Gomez wrote:
> -Wstringop-truncation warning was introduced in GCC-8 as truncation
> checker for strncpy and strncat.
>
> Systems using gcc version >= 8 would receive the following warnings:
>
> read_config_yy.c: In function ???yyparse???:
> read_config_yy.y:1594:2: warning: ???strncpy??? specified bound 16 equals destination size [-Wstringop-truncation]
>  1594 |  strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> read_config_yy.y:1384:2: warning: ???strncpy??? specified bound 256 equals destination size [-Wstringop-truncation]
>  1384 |  strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> read_config_yy.y:692:2: warning: ???strncpy??? specified bound 108 equals destination size [-Wstringop-truncation]
>   692 |  strncpy(conf.local.path, $2, UNIX_PATH_MAX);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> read_config_yy.y:169:2: warning: ???strncpy??? specified bound 256 equals destination size [-Wstringop-truncation]
>   169 |  strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> read_config_yy.y:119:2: warning: ???strncpy??? specified bound 256 equals destination size [-Wstringop-truncation]
>   119 |  strncpy(conf.logfile, $2, FILENAME_MAXLEN);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> main.c: In function ???main???:
> main.c:168:5: warning: ???strncpy??? specified bound 4096 equals destination size [-Wstringop-truncation]
>   168 |     strncpy(config_file, argv[i], PATH_MAX);
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Fix the issue by checking for string length first. Also using
> snprintf instead.
>
> In addition, correct an off-by-one when warning about maximum config
> file path length.
>
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
> ---
>  src/main.c           |  4 ++--
>  src/read_config_yy.y | 35 +++++++++++++++++++++++++++--------
>  2 files changed, 29 insertions(+), 10 deletions(-)
>
> diff --git a/src/main.c b/src/main.c
> index 7062e12..d4fbbfa 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -165,13 +165,13 @@ int main(int argc, char *argv[])
>  			break;
>  		case 'C':
>  			if (++i < argc) {
> -				strncpy(config_file, argv[i], PATH_MAX);
>  				if (strlen(argv[i]) >= PATH_MAX){
>  					config_file[PATH_MAX-1]='\0';
>  					dlog(LOG_WARNING, "Path to config file"
>  					     " to long. Cutting it down to %d"
> -					     " characters", PATH_MAX);
> +					     " characters", PATH_MAX - 1);
>  				}
> +				snprintf(config_file, PATH_MAX, "%.*s", PATH_MAX - 1, argv[i]);
>  				break;
>  			}
>  			show_usage(argv[0]);
> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index 4311cd6..696a86d 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -116,7 +116,12 @@ logfile_bool : T_LOG T_OFF
>
>  logfile_path : T_LOG T_PATH_VAL
>  {
> -	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
> +	if (strlen($2) >= FILENAME_MAXLEN) {
> +		dlog(LOG_ERR, "Filename is longer than %u characters",
> +		     FILENAME_MAXLEN - 1);
> +		exit(EXIT_FAILURE);
> +	}
> +	snprintf(conf.logfile, FILENAME_MAXLEN, "%.*s", FILENAME_MAXLEN - 1, $2);
>  	free($2);
>  };
>
> @@ -166,7 +171,12 @@ syslog_facility : T_SYSLOG T_STRING
>
>  lock : T_LOCK T_PATH_VAL
>  {
> -	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
> +	if (strlen($2) >= FILENAME_MAXLEN) {
> +		dlog(LOG_ERR, "Filename is longer than %u characters",
> +		     FILENAME_MAXLEN - 1);
> +		exit(EXIT_FAILURE);
> +	}
> +	snprintf(conf.lockfile, FILENAME_MAXLEN, "%.*s", FILENAME_MAXLEN - 1, $2);
>  	free($2);
>  };
>
> @@ -689,13 +699,13 @@ unix_options:
>
>  unix_option : T_PATH T_PATH_VAL
>  {
> -	strncpy(conf.local.path, $2, UNIX_PATH_MAX);
> -	free($2);
> -	if (conf.local.path[UNIX_PATH_MAX - 1]) {
> +	if (strlen($2) >= UNIX_PATH_MAX) {
>  		dlog(LOG_ERR, "UNIX Path is longer than %u characters",
>  		     UNIX_PATH_MAX - 1);
>  		exit(EXIT_FAILURE);
>  	}
> +	snprintf(conf.local.path, UNIX_PATH_MAX, "%.*s", UNIX_PATH_MAX - 1, $2);
> +	free($2);
>  };
>
>  unix_option : T_BACKLOG T_NUMBER
> @@ -1381,7 +1391,12 @@ stat_logfile_bool : T_LOG T_OFF
>
>  stat_logfile_path : T_LOG T_PATH_VAL
>  {
> -	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
> +	if (strlen($2) >= FILENAME_MAXLEN) {
> +		dlog(LOG_ERR, "Log file path is longer than %u characters",
> +		     FILENAME_MAXLEN - 1);
> +		exit(EXIT_FAILURE);
> +	}
> +	snprintf(conf.stats.logfile, FILENAME_MAXLEN, "%.*s", FILENAME_MAXLEN - 1, $2);
>  	free($2);
>  };
>
> @@ -1589,11 +1604,15 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
>  		exit(EXIT_FAILURE);
>  		break;
>  	}
> +	if (strlen($2) >= CTD_HELPER_NAME_LEN) {
> +		dlog(LOG_ERR, "CTD helper name is longer than %u characters",
> +		     CTD_HELPER_NAME_LEN - 1);
> +		exit(EXIT_FAILURE);
> +	}
>
>  	policy = (struct ctd_helper_policy *) &e->data;
> -	strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
> +	snprintf(policy->name, CTD_HELPER_NAME_LEN, "%.*s", CTD_HELPER_NAME_LEN - 1, $2);
>  	free($2);
> -	policy->name[CTD_HELPER_NAME_LEN-1] = '\0';
>  	/* Now object is complete. */
>  	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
>  	stack_item_push(&symbol_stack, e);
> --
> 2.23.0.rc1
>
There is absolutely no need to change code to eliminate GCC warnings.

If you are satisfied that the code is good, put these lines near the start, e.g.
before any #include lines:

> #pragma GCC diagnostic ignored "-Wpragmas"
> #pragma GCC diagnostic ignored "-Wstringop-truncation"

The first pragma stops old GCC compilers warning about the unrecognised second
pragma

The second pragma suppresses the new warning.

Cheers ... Duncan.
