From: "Gary W. Smith" <gary@primeexalia.com>
Subject: Re: iptables/netlink/java
Date: Thu, 22 Dec 2005 12:39:28 -0800
Message-ID: <BFD04F00.B51C%gary@primeexalia.com>
References: <1135283817.12214.35.camel@OSCARLAPLIN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <oscar@ufomechanic.net>,
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: <1135283817.12214.35.camel@OSCARLAPLIN>
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

I would think, for performance reasons, that Java would not be the way to
go.  If I recall there was a similar question some months ago.  You might
want to check the archives.


On 12/22/05 12:36 PM, "Oscar Mechanic" <oscar@ufomechanic.net> wrote:

> Has anyone successfully managed to catch a Netlink packet with Java only
> code. 
> 
> I would be delighted just to know I am not wasting my time without a
> native interface and suprisingly google/freshmeat/sourceforge has little
> on the subject.
> 
> I am trying to catch ULOG pkts with a Java only (JNI and me do not get
> on).
> 
> Regards
> Oscar
> 
> 
