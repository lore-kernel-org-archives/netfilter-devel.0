From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: License of libiptc
Date: Fri, 13 Aug 2004 18:04:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408131750490.9373@filer.marasystems.com>
References: <05FEBCD8-ED29-11D8-9EB5-000A95678CE8@norad.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stefan Arentz <stefan.arentz@norad.org>
In-Reply-To: <05FEBCD8-ED29-11D8-9EB5-000A95678CE8@norad.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 13 Aug 2004, Stefan Arentz wrote:

> We are currently using libiptc in our (not yet released) product to access 
> functionality that is not accessible through the iptables command. During a 
> license/code review I noticed that the license of libiptc is GPL instead of 
> LGPL. As we are not yet in the position to release our code this is a problem 
> for us.

Last time this question came up the Netfilter core team expressed a very 
strong GPL opinion and I do not think their minds have changed. And in 
addition you also need to consider the license of each and every extension 
you are using which may each have different copyrights.

Btw, what operations do you use libiptc for which is not accessible using 
the iptables suite of commands? (iptables / iptables-save / 
iptables-restore)

Regards
Henrik
