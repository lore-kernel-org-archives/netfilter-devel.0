From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Wed, 19 Dec 2007 20:03:05 +0100
Message-ID: <47696AE9.6090201@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com> <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Damien Th=E9bault wrote:
> Hello,
>=20
> I sent the quoted mail to linux-net with my problem yesterday, but I
> did a git bisect today and I got the following output :
>=20
>> 2bf540b73ed5b304e84bb4d4c390d49d1cfa0ef8 is first bad commit
>> commit 2bf540b73ed5b304e84bb4d4c390d49d1cfa0ef8
>> Author: Patrick McHardy <kaber@trash.net>
>> Date:   Wed Dec 13 16:54:25 2006 -0800
>>
>>     [NETFILTER]: bridge-netfilter: remove deferred hooks
>>
>>     Remove the deferred hooks and all related code as scheduled in
>>     feature-removal-schedule.
>>
>>     Signed-off-by: Patrick McHardy <kaber@trash.net>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> :040000 040000 c49ea947455937566b6129991dde5e86f2453aae 6611736ce5c0=
fcde7627494b66b9ea94e37ea42e M      Documentation
>> :040000 040000 d0dd0700fe68f98b52687be3a0c31d73f7b15b81 f8ddf15a0389=
c5f5b7f2c11d7d0db039a660e1d5 M      include
>> :040000 040000 dafccf7ff8657be9adca6b28dbd365cdd6c01ca5 3eeb1cb4b16c=
c5cb698ab559b47ea6b0991d4d3a M      net
>=20
> With exactly this version, the behaviour is similar with what I see
> with 2.6.23 and 2.6.24-rc5 (see below).


Could you capture the conntrack events of the non-working
case with (run in parallel):

conntrack -E
conntrack -E expect
