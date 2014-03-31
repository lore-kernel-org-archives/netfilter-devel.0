From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd RFC PATCH 0/2] introduce new string output plugin
Date: Mon, 31 Mar 2014 22:51:19 +0200
Message-ID: <1396299079.8629.73.camel@tiger2>
References: <20140329042336.GA22821@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:60649 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaCaUvg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:51:36 -0400
In-Reply-To: <20140329042336.GA22821@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Sat, 2014-03-29 at 13:23 +0900, Ken-ichirou MATSUZAWA wrote:
>   Hello,
>  
> I started to add new output plugin which work with graphite or statsd. Would you
> review these patches? I think this SPRINT output plugin has two issues and may
> I ask?
>  
> * multiple files for one plugin
>   I use flex and bison and need to separate source files. Is it acceptable?

I'm a bit reluctant to use flex and bison for that. How complicated
would it be to use a hand-made parsing here ?
 
> * use double calc operation
>   To tell statsd total amount bytes, I introduce calc operation (but '+' only now)
>   not using correct ULOGD_RET_ type but regard all of them as double.
>   It seems it is enough as of my purpose.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

