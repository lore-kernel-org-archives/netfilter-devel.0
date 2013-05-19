From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] bridge: netfilter: using strlcpy() instead of strncpy()
Date: Sun, 19 May 2013 21:43:43 +0200
Message-ID: <51992B6F.70309@pandora.be>
References: <5195E53A.4060406@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: bart.de.schuymer@pandora.be, pablo@netfilter.org, kaber@trash.net,
	stephen@networkplumber.org, David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux-foundation.org,
	netdev <netdev@vger.kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5195E53A.4060406@asianux.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Op 17/05/2013 10:07, Chen Gang schreef:
>
> 'name' has already set all zero when it is defined, so not need let
> strncpy() to pad it again.
>
> 'name' is a string, better always let is NUL terminated, so use
> strlcpy() instead of strncpy().
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
Acked-by: Bart De Schuymer <bdschuym@pandora.be>
