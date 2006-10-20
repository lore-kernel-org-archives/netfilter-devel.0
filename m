From: Maik Hentsche <maik@mm-double.de>
Subject: Re: How many rules were supported iptables?
Date: Fri, 20 Oct 2006 08:47:50 +0200
Message-ID: <1161326870.453871162638b@www.domainfactory-webmail.de>
References: <003b01c6f40f$9700b2d0$1319939c@LGE.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <003b01c6f40f$9700b2d0$1319939c@LGE.NET>
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

Zitat von =EC=9D=B4=EA=B7=BC=EC=88=98 <kslee109@gmail.com>:

> If some rules don't operate normally, how many rules iptables does
> support??

According to my own tests on a dual Opteron 2,4 GHz-System with 2 GB
RAM, more than 5000 rules decreased the throughput dramatically to
abround 4 MBit/s an a 100MBit interface, even through, these were empty
rules with no -j target. Having such a target will surely decrease the
throughput even more. Thus is discourage you from using so many rules.

so long
Maik
