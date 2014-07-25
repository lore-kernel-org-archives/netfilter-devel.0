From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: don't output error message redundantly
Date: Fri, 25 Jul 2014 15:00:27 +0200
Message-ID: <20140725130027.GA13940@salvia>
References: <53CF53DD.6020308@cn.fujitsu.com>
 <20140724114946.GA21812@salvia>
 <53D1AD93.7010005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58486 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaGYNAR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:00:17 -0400
Content-Disposition: inline
In-Reply-To: <53D1AD93.7010005@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 25, 2014 at 09:06:27AM +0800, Duan Jiong wrote:
> 
> The function led_trigger_register() will only return -EEXIST when
> error arises.

Applied, thanks.
