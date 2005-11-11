From: Hai Wang <pppoe.pppoa@gmail.com>
Subject: Compilation Issue on RG9
Date: Fri, 11 Nov 2005 08:43:38 -0500
Message-ID: <5efe1e0b0511110543v7d24c88bmc7c0dd761e502f01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello everyone


 I encountered a problem when I tried to compile iptables-1.3.4 on RH9 (
2.4.25), I got the following errors, please shed some lights on it.
 Thanks!
 Hai




ensions/libipt_time_sh.o -c extensions/libipt_time.c
extensions/libipt_time.c: In function `init':
extensions/libipt_time.c:66: structure has no member named `date_start'
extensions/libipt_time.c:67: structure has no member named `date_stop'
extensions/libipt_time.c: In function `parse':
extensions/libipt_time.c:394: structure has no member named `date_start'
extensions/libipt_time.c:407: structure has no member named `date_stop'
extensions/libipt_time.c: In function `print':
extensions/libipt_time.c:489: structure has no member named `date_start'
extensions/libipt_time.c:492: structure has no member named `date_start'
extensions/libipt_time.c:494: structure has no member named `date_stop'
extensions/libipt_time.c:497: structure has no member named `date_stop'
extensions/libipt_time.c: In function `save':
extensions/libipt_time.c:524: structure has no member named `date_start'
extensions/libipt_time.c:525: structure has no member named `date_stop'
make: *** [extensions/libipt_time_sh.o] Error 1
