From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd RFC PATCH 0/2] introduce new string output plugin
Date: Sat, 29 Mar 2014 13:23:36 +0900
Message-ID: <20140329042336.GA22821@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59318 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaC2EXo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:23:44 -0400
Received: by mail-pb0-f44.google.com with SMTP id rp16so5876090pbb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 21:23:44 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hello,
 
I started to add new output plugin which work with graphite or statsd. Would you
review these patches? I think this SPRINT output plugin has two issues and may
I ask?
 
* multiple files for one plugin
  I use flex and bison and need to separate source files. Is it acceptable?
 
* use double calc operation
  To tell statsd total amount bytes, I introduce calc operation (but '+' only now)
  not using correct ULOGD_RET_ type but regard all of them as double.
  It seems it is enough as of my purpose.

Thanks.
