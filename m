From: Patrick McHardy <kaber@trash.net>
Subject: Re: LibIPQ issue
Date: Mon, 7 Mar 2005 20:30:03 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0503072027540.5934@kaber.coreworks.de>
References: <e54bc1880503070451419fc57@mail.gmail.com>
	<422C52AB.4030801@trash.net>
	<e54bc1880503071117322999d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279739137-557744543-1110223803=:5934"
Cc: netfilter-devel@lists.netfilter.org
To: =?x-unknown?B?U+lyZ2lv?= Bernardino <sergio.bernardino@gmail.com>
In-Reply-To: <e54bc1880503071117322999d@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279739137-557744543-1110223803=:5934
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 7 Mar 2005, [x-unknown] S=E9rgio Bernardino wrote:

> I've always tested it with two or three different machines and the
> only rerouting that always worked was the one that occurred when i
> changed packet caught in LOCAL_OUT. Curiously enough the packet that i
> mangle in PRE_ROUTING seems to disappear. It doesn't "show" on the
> current machine (machine B, according to my previous example), on the
> intended machine (machine C) and i can't seem to track it with tcpdump
> after i committed the changes and ACCEPTed the packet.
> The example i gave with LOCAL_OUT rerouting a packet to make it seem
> like it's a localhost packet is just that, an example. In fact, i can
> reroute packets intended to a machine so that they show up on another
> one by changing them in LOCAL_OUT. It works fine. But since you say
> that that ip_queue manually reroutes the packets, the situation is
> clearly different from what occurs in PRE_ROUTING. I pretty certain
> that the information is modified correctly. In fact, the code i use to
> change packets caught in PRE_ROUTING is virtually identical to the
> code i use to change packets caught in LOCAL_OUT. So, basically, i'm
> quite unsure of what's exactly wrong. Specially since you've confirmed
> that it should work.

Please send the code you use for testing so I can try myself.

Regards
Patrick
--279739137-557744543-1110223803=:5934--
