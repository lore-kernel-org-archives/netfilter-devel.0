Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C153BB50;
	Mon,  2 Sep 2024 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725295819; cv=none; b=foegaT7R453KgdD4UkjdEE03aJYAMynyqeyIC+u7REHjZ9CBRropZ+f0QOS5FNSmMcTpw7cffhVzqsYhhHB5Tn77pWaRND1LNWUDAMReBKAHJ4sVXNHsE89pm9MSyWe9aaqgwvjCp1vj3kh3FjlWbRsD7NAgZqaR0r6nNRgwPO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725295819; c=relaxed/simple;
	bh=IaK+IdNeYH4BtKZYdqUZaylNjavpjXvtbpzDCLijfH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdpT3iofgMsJ0OcRKgiLqGJdpknuDs8LQ/4daA3c51tsNLf3Wd+ODSane8BONTcseQltxf2RV63csXWdwJOJIvhPtFO8T51xbXyuDZ98Yf95ivL6nrGOY6JS2r7SD4X+XLGNz1GSUu1893yrP+u7+ACnNhFOq00OqNre0wWRFgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buBZGwLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buBZGwLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F750C4CEC2;
	Mon,  2 Sep 2024 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725295819;
	bh=IaK+IdNeYH4BtKZYdqUZaylNjavpjXvtbpzDCLijfH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=buBZGwLBad1ESYcxR31eVXgQrLwOSqumkYy0e/JomQ6EiBynvRcGaOFMm1qOaVeHB
	 /yJnGywXft+4GlZEOQ6uKIjtHu4879NCRFPcgvy4GZJ8tNgO6SOptn6cXSuP0tjeS+
	 KeP0CYLeyi2/aNBJBnxWKNbMcHsCSNbrnXvXVhjhp/Ik73PhhCqBi6HcKFWwZNqfot
	 +STyq/ZlojpsOEIz2cbY+YoBzeZ1wsxvvqcbobg9ST3+lrR3O8eHyqMGMeo5Bo5jeu
	 akiPGn13w3HBrKNuHuxKQSMjJdDmbwlms17MWRLwK9ErdysP6S7GO55zXwmLfGx4ba
	 MsRHQpojsuX3A==
Message-ID: <2f5146ff-507d-4cab-a195-b28c0c9e654e@kernel.org>
Date: Mon, 2 Sep 2024 10:50:17 -0600
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 3/3] ipv4: Centralize TOS matching
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, dsahern@kernel.org, gnault@redhat.com,
 pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
References: <20240814125224.972815-1-idosch@nvidia.com>
 <20240814125224.972815-4-idosch@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20240814125224.972815-4-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/14/24 6:52 AM, Ido Schimmel wrote:
> diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
> index 0cc2c23b47f8..10bdd7e7107f 100644
> --- a/include/uapi/linux/in_route.h
> +++ b/include/uapi/linux/in_route.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_IN_ROUTE_H
>  #define _LINUX_IN_ROUTE_H
>  
> +#include <linux/ip.h>
> +
>  /* IPv4 routing cache flags */
>  
>  #define RTCF_DEAD	RTNH_F_DEAD

This breaks compile of iproute2 (on Ubuntu 22.04 at least):

In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:25: warning: "IPTOS_TOS" redefined
   25 | #define IPTOS_TOS(tos)          ((tos)&IPTOS_TOS_MASK)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:212: note: this is the location of the
previous definition
  212 | #define IPTOS_TOS(tos)          ((tos) & IPTOS_TOS_MASK)
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:29: warning: "IPTOS_MINCOST" redefined
   29 | #define IPTOS_MINCOST           0x02
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:217: note: this is the location of the
previous definition
  217 | #define IPTOS_MINCOST           IPTOS_LOWCOST
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:31: warning: "IPTOS_PREC_MASK" redefined
   31 | #define IPTOS_PREC_MASK         0xE0
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:222: note: this is the location of the
previous definition
  222 | #define IPTOS_PREC_MASK                 IPTOS_CLASS_MASK
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:32: warning: "IPTOS_PREC" redefined
   32 | #define IPTOS_PREC(tos)         ((tos)&IPTOS_PREC_MASK)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:223: note: this is the location of the
previous definition
  223 | #define IPTOS_PREC(tos)                 IPTOS_CLASS(tos)
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:33: warning: "IPTOS_PREC_NETCONTROL" redefined
   33 | #define IPTOS_PREC_NETCONTROL           0xe0
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:224: note: this is the location of the
previous definition
  224 | #define IPTOS_PREC_NETCONTROL           IPTOS_CLASS_CS7
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:34: warning: "IPTOS_PREC_INTERNETCONTROL"
redefined
   34 | #define IPTOS_PREC_INTERNETCONTROL      0xc0
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:225: note: this is the location of the
previous definition
  225 | #define IPTOS_PREC_INTERNETCONTROL      IPTOS_CLASS_CS6
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:35: warning: "IPTOS_PREC_CRITIC_ECP" redefined
   35 | #define IPTOS_PREC_CRITIC_ECP           0xa0
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:226: note: this is the location of the
previous definition
  226 | #define IPTOS_PREC_CRITIC_ECP           IPTOS_CLASS_CS5
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:36: warning: "IPTOS_PREC_FLASHOVERRIDE" redefined
   36 | #define IPTOS_PREC_FLASHOVERRIDE        0x80
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:227: note: this is the location of the
previous definition
  227 | #define IPTOS_PREC_FLASHOVERRIDE        IPTOS_CLASS_CS4
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:37: warning: "IPTOS_PREC_FLASH" redefined
   37 | #define IPTOS_PREC_FLASH                0x60
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:228: note: this is the location of the
previous definition
  228 | #define IPTOS_PREC_FLASH                IPTOS_CLASS_CS3
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:38: warning: "IPTOS_PREC_IMMEDIATE" redefined
   38 | #define IPTOS_PREC_IMMEDIATE            0x40
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:229: note: this is the location of the
previous definition
  229 | #define IPTOS_PREC_IMMEDIATE            IPTOS_CLASS_CS2
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:39: warning: "IPTOS_PREC_PRIORITY" redefined
   39 | #define IPTOS_PREC_PRIORITY             0x20
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:230: note: this is the location of the
previous definition
  230 | #define IPTOS_PREC_PRIORITY             IPTOS_CLASS_CS1
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:40: warning: "IPTOS_PREC_ROUTINE" redefined
   40 | #define IPTOS_PREC_ROUTINE              0x00
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:231: note: this is the location of the
previous definition
  231 | #define IPTOS_PREC_ROUTINE              IPTOS_CLASS_CS0
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:48: warning: "IPOPT_COPIED" redefined
   48 | #define IPOPT_COPIED(o)         ((o)&IPOPT_COPY)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:240: note: this is the location of the
previous definition
  240 | #define IPOPT_COPIED(o)         ((o) & IPOPT_COPY)
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:49: warning: "IPOPT_CLASS" redefined
   49 | #define IPOPT_CLASS(o)          ((o)&IPOPT_CLASS_MASK)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:241: note: this is the location of the
previous definition
  241 | #define IPOPT_CLASS(o)          ((o) & IPOPT_CLASS_MASK)
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:50: warning: "IPOPT_NUMBER" redefined
   50 | #define IPOPT_NUMBER(o)         ((o)&IPOPT_NUMBER_MASK)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:242: note: this is the location of the
previous definition
  242 | #define IPOPT_NUMBER(o)         ((o) & IPOPT_NUMBER_MASK)
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:54: warning: "IPOPT_MEASUREMENT" redefined
   54 | #define IPOPT_MEASUREMENT       0x40
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:247: note: this is the location of the
previous definition
  247 | #define IPOPT_MEASUREMENT       IPOPT_DEBMEAS
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:57: warning: "IPOPT_END" redefined
   57 | #define IPOPT_END       (0 |IPOPT_CONTROL)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:251: note: this is the location of the
previous definition
  251 | #define IPOPT_END               IPOPT_EOL
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:58: warning: "IPOPT_NOOP" redefined
   58 | #define IPOPT_NOOP      (1 |IPOPT_CONTROL)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:253: note: this is the location of the
previous definition
  253 | #define IPOPT_NOOP              IPOPT_NOP
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:59: warning: "IPOPT_SEC" redefined
   59 | #define IPOPT_SEC       (2 |IPOPT_CONTROL|IPOPT_COPY)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:259: note: this is the location of the
previous definition
  259 | #define IPOPT_SEC               IPOPT_SECURITY
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:60: warning: "IPOPT_LSRR" redefined
   60 | #define IPOPT_LSRR      (3 |IPOPT_CONTROL|IPOPT_COPY)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:260: note: this is the location of the
previous definition
  260 | #define IPOPT_LSRR              131             /* loose source
route */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:61: warning: "IPOPT_TIMESTAMP" redefined
   61 | #define IPOPT_TIMESTAMP (4 |IPOPT_MEASUREMENT)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:257: note: this is the location of the
previous definition
  257 | #define IPOPT_TIMESTAMP         IPOPT_TS
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:63: warning: "IPOPT_RR" redefined
   63 | #define IPOPT_RR        (7 |IPOPT_CONTROL)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:255: note: this is the location of the
previous definition
  255 | #define IPOPT_RR                7               /* record packet
route */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:64: warning: "IPOPT_SID" redefined
   64 | #define IPOPT_SID       (8 |IPOPT_CONTROL|IPOPT_COPY)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:262: note: this is the location of the
previous definition
  262 | #define IPOPT_SID               IPOPT_SATID
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:65: warning: "IPOPT_SSRR" redefined
   65 | #define IPOPT_SSRR      (9 |IPOPT_CONTROL|IPOPT_COPY)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:263: note: this is the location of the
previous definition
  263 | #define IPOPT_SSRR              137             /* strict source
route */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:66: warning: "IPOPT_RA" redefined
   66 | #define IPOPT_RA        (20|IPOPT_CONTROL|IPOPT_COPY)
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:264: note: this is the location of the
previous definition
  264 | #define IPOPT_RA                148             /* router alert */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:77: warning: "IPOPT_NOP" redefined
   77 | #define IPOPT_NOP IPOPT_NOOP
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:252: note: this is the location of the
previous definition
  252 | #define IPOPT_NOP               1               /* no operation */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:78: warning: "IPOPT_EOL" redefined
   78 | #define IPOPT_EOL IPOPT_END
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:250: note: this is the location of the
previous definition
  250 | #define IPOPT_EOL               0               /* end of option
list */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:79: warning: "IPOPT_TS" redefined
   79 | #define IPOPT_TS  IPOPT_TIMESTAMP
      |
In file included from iproute.c:17:
/usr/include/netinet/ip.h:256: note: this is the location of the
previous definition
  256 | #define IPOPT_TS                68              /* timestamp */
      |
In file included from ../include/uapi/linux/in_route.h:5,
                 from iproute.c:19:
../include/uapi/linux/ip.h:87:8: error: redefinition of ‘struct iphdr’
   87 | struct iphdr {
      |        ^~~~~
In file included from iproute.c:17:
/usr/include/netinet/ip.h:44:8: note: originally defined here
   44 | struct iphdr
      |        ^~~~~
