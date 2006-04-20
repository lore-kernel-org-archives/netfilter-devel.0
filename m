From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: Strange MASQUERADING behaviour, bug or feature?
Date: Thu, 20 Apr 2006 13:16:39 +0200 (CEST)
Message-ID: <45730.217.166.60.19.1145531799.squirrel@217.166.60.19>
References: <44440CD2.6060006@rtij.nl> <444610DD.9000807@ufomechanic.net>   
	<44466513.8080000@rtij.nl> <4447422A.20704@ufomechanic.net>
	<40417.217.166.60.19.1145529618.squirrel@217.166.60.19>
	<44476A21.7070609@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44476A21.7070609@ufomechanic.net>
To: "Amin Azez" <azez@ufomechanic.net>
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

Amin Azez zei:
> I don't have an answer, unless you can use the --tee option of ipt_route
> to divert a copy of packets to your dummy interface.
> If you use ipt_condition with this, then you can control when it happens
> with a /proc file.

That's a good idea, I'll try that!

M4
