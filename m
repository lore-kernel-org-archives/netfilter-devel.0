From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip accounting
Date: Thu, 20 May 2004 16:04:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405201604.46581.thomas.jarosch@intra2net.com>
References: <40ACAFDA.7497.4A56EAD@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: voja.t@mail.nis-naftagas.co.yu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <40ACAFDA.7497.4A56EAD@localhost>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Toholj,

> I heard that there was a discussion about "accounting based on ip address
> upl/dnl". If that's right, could someone send me the whole story?

There are currently four ways to do traffic account:

1. Setup counting rules that do nothing. Readout the counters using
iptables/libiptc. Not a very efficent way if you want to read
out the counters every second, but easy to setup.

"iptables -n  -v -L" for example shows the packet counters.

2. Use the ipt_account match from here:
http://www.barbara.eu.org/~quaker/ipt_account/
(Wasn't there an english version somewhere?)

3. ulog-based traffic accounting:
http://savannah.nongnu.org/projects/ulog-acctd

4. Use the high performance ipt_ACCOUNT target from here:
http://www.intra2net.com/opensource/ipt_account/

It's more difficult to setup, but very efficent ;-)

Cheers,
Thomas
