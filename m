From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Thu, 20 Dec 2007 12:06:39 +0100
Message-ID: <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>
	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>
	 <47696AE9.6090201@trash.net>
	 <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>
	 <476A3E93.3010400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <476A3E93.3010400@trash.net>
Content-Disposition: inline
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Dec 20, 2007 11:06 AM, Patrick McHardy <kaber@trash.net> wrote:
> That actually looks like it works properly.
>
> New control connection:
>
> [...]
>
> New expectation for data connection:
>
> [...]
>
> New data connection machting expectation, both source and
> destination properly NATed:
>
> [...]
>
> Data connection closed
>
> [...]
>
> Control connection closed
>
> [...]
>
> Both connections destroyed
>

Yes, when I'm using ip addresses with the same length, the conntrack
-E output is similar, and it's working.
But if I change the router's "wan"-side ip address to be longer or
shorter than the client's ip address, then it's non-working again.

I don't think it's something in the configuration : the results are
present on two different computers, one being a x86 little endian
debian laptop where I did the bisect, the other being an arm xscale
big endian board with a custom distro (nothing funny here, just
kernel, drivers, busybox and  some utilities).

Well, I'm sorry, I don't want to bother anyone, but those are really
the results I'm seeing.
-- 
Damien Thebault
