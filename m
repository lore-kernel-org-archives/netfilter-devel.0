From: Punky <punkytse@gmail.com>
Subject: Re: trying to revive rtsp
Date: Tue, 21 Feb 2006 10:02:16 +0800
Message-ID: <1a49df600602201802pa26daa1jfce4301f52d07b6a@mail.gmail.com>
References: <43F87D21.7090305@kde.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mickael Marchand <marchand@kde.org>
In-Reply-To: <43F87D21.7090305@kde.org>
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

Hi Mickael,

I am doing the same thing - try to port rtsp to 2.6.15.  And I
encountered problem in porting rtsp nat code.  You can refer to mms
and talk conntrack/nat code to see how API are changed.  Moreover, I
used svn to check how codes are change in each revision as well.

Moreover, if you have any news on the porting, please let me know.

Regards,
Punky

On 2/19/06, Mickael Marchand <marchand@kde.org> wrote:
> Hi,
>
> I am really a newbie to the netfilter coding world, so please forgive
> any stupid questions :)
>
> I have mostly ported the old rtsp conntrack+nat code to recent 2.6
> kernels, compiles and loads fine into the kernel,
> but I have some problems to make it work now :)
>
> the initial TCP connexion to the RTSP server:554 is correctly detected
> and the expectation packet seems to be properly setup :
> cat /proc/net/ip_conntrack_expect
> 255 proto=3D17 src=3D212.27.38.253 dst=3D10.0.0.2 sport=3D0 dport=3D33302
>
> 212.27.38.253 is the RTSP server, 10.0.0.2 is the client, 10.0.0.1 is
> the netfilter box.
>
> so once the TCP connexion has been established, we expect a UDP stream
> from the server going to the client port 33302.
>
> my problem is that the expected packet does not get through the
> netfilter box, I can see the UDP stream coming from the RTSP server and
> going to my netfilter box,
> the expectation packet seems to get removed of
> /proc/net/ip_conntrack_expect as well (so basically it looks all good)
> but the netfilter box does not forward packets to 10.0.0.2.
> so it looks like a NAT problem to me, maybe the UDP packets are not
> getting NAT-ed back to the client.
>
> my first question would be :
> is it expected to see 10.0.0.2 in the expected paquet ?
> should not it be my external IP instead ?
>
> any tips in what direction I could look ? :)
>
> thanks for any help
>
> Cheers,
> Mik
> (Please CC-me in answers :)
>
>


--
--
Regards,
Punky
P U N K N ! X  . c o m
Technology + Lifestyle
(http://www.punknix.com)

Voyage Linux
(http://www.voyage.hk/software/voyage.html)
