From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue 4/4] Switch documentation style to doxygen.
Date: Mon, 22 Dec 2008 11:45:09 +0100
Message-ID: <494F6FB5.3090204@netfilter.org>
References: <1229722591-7836-1-git-send-email-eric@inl.fr> <1229722591-7836-5-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44087 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752013AbYLVKpW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:45:22 -0500
In-Reply-To: <1229722591-7836-5-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies the documentation format to switch to doxygen
> format. This leads to a interesting and useful output. An example
> can be found at the following url:
> 	http://www.nufw.org/doc/libnetfilter_queue/

I was thinking about using kerneldoc utility, but doxygen is better at
this moment. Could you also send the doxygen configuration file to put
it in the git tree?

Once I generate the doxygen documentation, I'm going to add it to the
netfilter website.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
