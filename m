From: Dave Taht <dave.taht@gmail.com>
Subject: issues with shaping cake to 60 gbits or in unlimited mode at 100gbps
Date: Mon, 4 Jun 2018 14:32:42 -0700
Message-ID: <CAA93jw4KdC72309Y++-vanu4m_L6bwxY2k9EQSGbwJKgPYvEFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cake List <cake@lists.bufferbloat.net>,
        George Amanakis <gamanakis@gmail.com>,
        Pete Heist <peteheist@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Netfilter Development Mailinglist
        <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I would like to point a finger at the mlx5 code rather than cake itself,
I am wondering if there is anyone out there with a different 100gps
capable device and setup that could give the sch_cake code a go?

we've been unable to duplicate the lockup we're seeing with the veth device=
s,
for example.

On Fri, Jun 1, 2018 at 11:17 AM, David Miller <davem@davemloft.net> wrote:
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Date: Fri, 01 Jun 2018 19:42:12 +0200
>
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>
>>> This patch series adds the CAKE qdisc, and has been split up to ease
>>> review.
>>>
>>> I have attempted to split out each configurable feature into its own pa=
tch.
>>> The first commit adds the base shaper and packet scheduler, while
>>> subsequent commits add the optional features. The full userspace API an=
d
>>> most data structures are included in this commit, but options not
>>> understood in the base version will be ignored.
>>
>> Hmm, there seems to be a lockup issue being triggered when running CAKE
>> at high speeds (>40 Gbps in my tests). Please drop this series for now,
>> we'll return for 4.19 with a revised version.
>
> Ok.
>
> Thanks for continuing to push this work along.



--=20

Dave T=C3=A4ht
CEO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-669-226-2619
