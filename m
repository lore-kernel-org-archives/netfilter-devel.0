From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/4, V2, libnftnl] tests: Fix segfaults due outbound
 access
Date: Sat, 13 Aug 2016 17:25:19 +0200
Message-ID: <55d5bbb9-bfba-5cb3-11d1-348ce2e20675@riseup.net>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net> <20160813101210.GD1376@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:35652 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbcHMPZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 11:25:24 -0400
In-Reply-To: <20160813101210.GD1376@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/13/2016 12:12 PM, Pablo Neira Ayuso wrote:
> On Fri, Aug 12, 2016 at 10:17:19PM +0200, Carlos Falgueras García wrote:
>> Changes random values for macros because the conversion to string of these
>> values are performed by accessing to an array of strings.
>
> Then, we should fix the functions to return "unknown" for out of bound
> access of the array.
>
> I think you have to fix this in the library, not the test.

The most common structure we have is this:

	static const char *element2str_array[MAX_ELEMENTS] {
		[ELEMENT_1]	= "element 1",
		...
		[ELEMENT_N]	= "element N",
	};

	static const char *element2str(uint32_t element) {
		if (element < MAX_ELEMENT)
			return "unkown";
		return element2str_array[element];
	}

I think it is better if we change it to a switch-case statement. I think 
a switch-case have the same performance and it is more robust due cases 
like this:

netfilter.h:
	enum {
		NFPROTO_UNSPEC =  0,
		NFPROTO_INET   =  1,
		NFPROTO_IPV4   =  2,
		NFPROTO_ARP    =  3,
		NFPROTO_NETDEV =  5,
		NFPROTO_BRIDGE =  7,
		NFPROTO_IPV6   = 10,
		NFPROTO_DECNET = 12,
		NFPROTO_NUMPROTO,
	};

utils.c:
	static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
		[NFPROTO_INET]		= "inet",
		[NFPROTO_IPV4]		= "ip",
		[NFPROTO_ARP]		= "arp",
		[NFPROTO_NETDEV]	= "netdev",
		[NFPROTO_BRIDGE]	= "bridge",
		[NFPROTO_IPV6]		= "ip6",
	};

We do not have all element in the translation table and elements have 
unconsecutives values.

Another possible solution is something like this:

	  static const char *element2str(uint32_t element) {
	- 	if (element < MAX_ELEMENT)
	+ 	if (element < MAX_ELEMENT || !element2str_array[element])
	  		return "unkown";
	  	return element2str_array[element];
	  }

What do you think?

Thanks.
