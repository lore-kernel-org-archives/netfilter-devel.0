From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 01 Jul 2012 13:19:04 +0100
Message-ID: <4FF04038.4080306@googlemail.com>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49888 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab2GAMTN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:19:13 -0400
In-Reply-To: <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> The hash:net,iface type is out for a long time. It is not possible to 
> change the meaning of src/dst without breaking backward compatibility, 
> therefore I won't do it.
It has nothing to do with "backward compatibility" at all, but 
everything to do with something which was done wrong initially and needs 
to be fixed. The fact that this "has been out for a long time" is not an 
excuse - if anything, it reflects pretty badly that this wasn't spotted 
earlier. Besides, when a bug is discovered do you write a man page 
documenting it or do you fix that particular bug?

>  As a "workaround" I tried to explain the meaning 
> of src/dst for iface as clearly as possible.
>   
As I stated before - documenting a bug doesn't make it right. The proper 
course of action is to fix that particular bug, not document it in a 
bloody man page!

