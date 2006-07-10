From: Svein Olav Bjerkeset <netfilter@bjerkeset.com>
Subject: Re: Patch for geoip to make it work with kernel 2.6.17
Date: Tue, 11 Jul 2006 01:52:00 +0200
Message-ID: <000801c6a47b$da7a0400$010210ac@BJERKESET.COM>
References: <twig.1152545608.74588@bugmachine.ca>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=iso-8859-1;
	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nib@istop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jix@bugmachine.ca, netfilter-devel@lists.netfilter.org
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

> Thank you! I've also got a patch from Krzysztof Ol=EAdzki on May 11=
.
> I'll have a look at it pretty soon.

I found the patch from Krzysztof Ol=EAdzki in the mailing list archiv=
es, but=20
could not get it to work on 2.6.17.x.
In his post he states that his patch is for 2.6.16.x, and if I rememb=
er=20
correctly I had geoip working with his
patch for 2.6.16.15.

On 2.6.17.4 with Krzysztof Ol=EAdzki's patch, I got an error message=
=20
"ip_tables: matchsize differ 0 !=3D 96" when
trying to add a geoip rule.

Svein Olav Bjerkeset=20
