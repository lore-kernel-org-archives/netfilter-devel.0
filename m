From: Michel Pereira <michel@michel.eti.br>
Subject: Re: 2.6.11 corrupting FTP session
Date: Sun, 20 Mar 2005 14:58:23 -0300
Message-ID: <1111341503.423db9bfcffb7@webmail.conectcor.com.br>
References: <1111176664.423b35d80b351@webmail.conectcor.com.br>
	<423DA1FB.6030209@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <423DA1FB.6030209@trash.net>
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

Quoting Patrick McHardy <kaber@trash.net>:
> What is your setup (NAT rules, network topology between client and
> server)?

   Firewall (a) -> Server on DMZ. (NAT of internal network connections)
   Firewall (b) -> Internal Network (without NAT of connections)

   b - iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
   b - iptables -A FORWARD -s myip -d 0/0 -m state --state NEW -j ACCEPT

   a - iptables -t nat -A PREROUTING -p TCP -s 0/0 -d 200.162.38.71 --dpo=
rt 21
-j DNAT --to IPonDMZ

Thank you
--
Michel Pereira
michel.pereira@eurorscg.com
+55 11 5105 0570
+55 11 5105 0569
www.eurorscg4d.com.br
Euro RSCG 4D

Unix Sex: unzip;strip;touch;finger;mount;fsck;more;yes;umount;sleep


----------------------------------------------------------------
Conectcor - velocidade com qualidade
www.conectcor.com.br
