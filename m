From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 5/7] Add handling of too long arguments.
Date: Mon, 18 Feb 2013 16:04:29 +0100
Message-ID: <1361199869.23642.89.camel@tiger2>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
	 <1361176668-22661-6-git-send-email-eric@regit.org>
	 <5121F757.9070808@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51181 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3BRPFA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:05:00 -0500
In-Reply-To: <5121F757.9070808@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2013-02-18 at 09:41 +0000, Mr Dash Four wrote:
> > +				"too long string value for key \"%s\"\n",
> >   
> "string value too long for key"

Thanks a lot. Fixing this and the other one!

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

