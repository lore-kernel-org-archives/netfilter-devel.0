From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: New extension: CRYPT target
Date: Sun, 21 May 2006 19:01:48 +0200
Message-ID: <44709CFC.7050007@gmx.net>
References: <44708E68.9080508@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <44708E68.9080508@speedy.com.ar>
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

Gervasio Bernal wrote:
> (on host A, 1.2.3.4, FTP client)
> # iptables -t mangle -A POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j
> CRYPT --cipher blowfish --key topsecret --mode ecb --direction encrypt

Ouch. If anybody runs ps while this iptables command is running, he has
your top secret key.

Does this provide any benefit over IPSEC?

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
