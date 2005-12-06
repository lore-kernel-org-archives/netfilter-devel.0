From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Proper detection of FTP-DATA
Date: Tue, 6 Dec 2005 16:09:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512061604120.1560@bizon.gios.gov.pl>
References: <C3FA62B1A90D7440B9B6C7C31895994F016C6D7A@zadbn02100.vodacom.corp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1186367373-1133881740=:1560"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pieter De Wit <pieter@vodacom.co.za>
In-Reply-To: <C3FA62B1A90D7440B9B6C7C31895994F016C6D7A@zadbn02100.vodacom.corp>
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

---187430788-1186367373-1133881740=:1560
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 6 Dec 2005, Pieter De Wit wrote:

> Hello Guys,
>
> How would you properly match FTP-DATA connections? I have tried the
> following and after checking the man pages, this should work ?!?
>
> iptables -A INPUT -p tcp -m tcp --dport=3D21 # For FTP-CTRL
> iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
> iptables -A INPUT -m state --state RELATED -j ACCEPT
>
> Let's just say outbound is ACCEPT *
>
> For passive FTP that should work, since the firewall (which is on the
> FTP Server) can match that ? Or can it ?

All you need is:
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -m conntrack -m helper --state RELATED --helper ftp -j AC=
CEPT

and:
modprobe ip_conntrack_ftp

You can also use less restricted version:
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1186367373-1133881740=:1560--
