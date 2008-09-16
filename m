From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik-X3B1VOXEql0@public.gmane.org>
Subject: netfilter kernel crash in ip_ct_refresh_acct /
	ip_conntrack with centos 5.x
Date: Tue, 16 Sep 2008 10:38:21 +0300
Message-ID: <20080916073821.GL13941@edu.joroinen.fi>
Reply-To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
Return-path: <centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.centos.org/pipermail/centos>
List-Post: <mailto:centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Sender: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
Errors-To: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Hello!

Has anyone seen this netfilter kernel crash? 

Images from the console of the crashed firewall:
http://pasik.reaktio.net/centos5-kernel-crash/

Firewall is HP DL360 G4 server running CentOS 5.x 32 bit. 

I've seen this firewall crashing multiple times, but I only started investigating it lately..

It has happened using CentOS 5.0, 5.1 and now also with 5.2. I'm not sure if
it was the same bug earlier, but at least the last two times (with CentOS 5.2) 
it has been the same, see screenshots.

Last lines of the console output:

EIP: [<f8af2c5c>] __ip_ct_refresh_acct+0xa1/0x129 [ip_conntrack] SS:ESP 0068:c0724e4c
 <0>Kernel panic - not syncing: Fatal exception in interrupt

At the moment firewall is running CentOS 5.2, Linux kernel 2.6.18-92.1.10.el5.centos.plus.

Any tips how to resolve this? 

-- Pasi
