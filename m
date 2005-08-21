From: Peter Surda <surda@shurdix.com>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 04:41:28 +0200
Message-ID: <20057214412813341@mail.routehat.org>
References: <4307CA57.9090600@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4307CA57.9090600@gmx.net>
Content-Disposition: inline
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

On Sun, 21 Aug 2005 02:27:03 +0200 Carl-Daniel Hailfinger
<c-d.hailfinger.devel.2005@gmx.net> wrote:

>Jan Engelhardt schrieb:
>> The question is: how different do all these 2000+ hosts need to be
>> classified?
>> I can't think of anything but to let everything through with possibly
>  ^^^^^^^^^^^^^^^^^^^^^^^^^
>> exceptions like SMTP and HTTP (going over proxies there).
>You haven't yet managed such a big student network, right?
Well, he perhaps hadn't, but I did and still do, several of them.

>being able to freely roam and still get access to their own services and
>having different rules, shaping based on traffic history, IP, port and
>building they're sitting in, DoS protection for the hosts behind, limits
>on filesharing, redirection of a few services, exceptions to all the
>rules above because of people being "important", load distribution etc.
I thought this for several years too. Then I discovered WRR and was able =
to
achieve much better results (both subjective perception of users and
measurements), not to mention that the required administration is much lo=
wer.

>Please don't criticize other people before understanding their problems.
You are of course right, original poster's situation seems very complex a=
nd such
a large amount of rules may be justified.

Furthermore may I suggest that only development be discussed here and not=
 "how
to use iptables properly"? LARTC might be a better place for that.

>Regards,
>Carl-Daniel
Yours sincerely,
Peter

--=20
http://www.shurdix.org - Linux distribution for routers and firewalls
