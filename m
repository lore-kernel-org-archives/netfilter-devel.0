From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: regression: Delete all reference to wlan0 in test
 files.
Date: Thu, 9 Oct 2014 18:55:57 +0200
Message-ID: <20141009165557.GA14090@salvia>
References: <1412772730-29161-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44719 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaJIQyl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:54:41 -0400
Content-Disposition: inline
In-Reply-To: <1412772730-29161-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 08, 2014 at 02:52:09PM +0200, Ana Rey wrote:
> There are false errors if it uses the automated regression testing
> without a wlan0 device in the system.
> 
> Deletes references to 'wlan0' in test files and replaces 'wlan0' by 'lo'
> or 'eth0' in the test files if it is possible.

OK, so we assume that tests run in a box with at least eth0. Fair
enough, applied thanks Ana.
