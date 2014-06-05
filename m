From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v4 3/3] expr: log: Do not print unset values in
 xml
Date: Thu, 5 Jun 2014 15:18:16 +0200
Message-ID: <20140605131816.GC20181@localhost>
References: <1401792116-17742-1-git-send-email-anarey@gmail.com>
 <1401792116-17742-4-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41823 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaFENSV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:18:21 -0400
Content-Disposition: inline
In-Reply-To: <1401792116-17742-4-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 03, 2014 at 12:41:56PM +0200, Ana Rey wrote:
> It changes the parse and the snprint functions to omit unset values.
> 
> If we used this rule:
> nft add rule ip test output log
> 
> We got this xml file:
> <rule><family>ip</family>
> <table>test</table>
> <chain>output</chain>
> <handle>88</handle>
> <expr type="log">
>         <prefix>(null)</prefix>
>         <group>0</group>
>         <snaplen>0</snaplen>
>         <qthreshold>0</qthreshold>
> </expr>
> </rule>
> 
> And It was imposible import this file.
> 
> Now, That rule creates this xml file without null values:
> 
> <rule><family>ip</family>
> <table>test</table>
> <chain>output</chain>
> <handle>88</handle>
> <expr type="log">
> </expr>
> </rule>
> 
> and It's possible import this xml file.

Applied, thanks Ana.
