From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: add level option to the log statement
Date: Fri, 25 Jul 2014 15:59:03 +0100
Message-ID: <eea89910-4060-4fd3-9eb7-6e2c1836edc0@email.android.com>
References: <1406242861-11855-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56283 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaGYO7I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:59:08 -0400
In-Reply-To: <1406242861-11855-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25. Juli 2014 00:01:01 GMT+01:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:

>+			|	LEVEL		STRING
>+			{
>+				if (strcmp($2, "emerg") == 0) {
>+					$<stmt>0->log.level = LOG_EMERG;
>+				} else if (strcmp($2, "alert") == 0) {
>+					$<stmt>0->log.level = LOG_ALERT;
>+				} else if (strcmp($2, "crit") == 0) {
>+					$<stmt>0->log.level = LOG_CRIT;
>+				} else if (strcmp($2, "err") == 0) {
>+					$<stmt>0->log.level = LOG_ERR;
>+				} else if (strcmp($2, "warn") == 0) {
>+					$<stmt>0->log.level = LOG_WARNING;
>+				} else if (strcmp($2, "notice") == 0) {
>+					$<stmt>0->log.level = LOG_NOTICE;
>+				} else if (strcmp($2, "info") == 0) {
>+					$<stmt>0->log.level = LOG_INFO;
>+				} else if (strcmp($2, "debug") == 0) {
>+					$<stmt>0->log.level = LOG_DEBUG;
>+				} else {
>+					erec_queue(error(&@2,
>+							 "invalid syslog level %s",
>+							 $2), state->msgs);
>+					YYERROR;

Any reason for not using the parser for the log levels?


