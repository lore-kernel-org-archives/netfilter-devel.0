From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Tue, 27 Nov 2007 16:27:15 -0800
Message-ID: <20071128002715.GA6555@linuxace.com>
References: <20071127190745.GA2080@linuxace.com> <Pine.LNX.4.64.0711280033300.4181@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:58871
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754982AbXK1A1Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:27:16 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711280033300.4181@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 28, 2007 at 12:34:31AM +0100, Jan Engelhardt wrote:
> Considering TCP only...
> 
> If my firewall allows 'NEW' connections (-m conntrack --ctstate NEW) on
> non-SYN packets, what good will xt_TIMEOUT do? If the ct entry times out,
> a new one will be created once the next packet flows.

Correct - in this case, it will not help at all.  But many rulesets
require (--state NEW) to be --syn, where this would help.

Phil
