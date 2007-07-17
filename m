From: "=?ISO-8859-2?Q?Stanis=B3aw_Pitucha?=" <viraptor@gmail.com>
Subject: Re: netfilter queue not on filter table
Date: Tue, 17 Jul 2007 16:34:34 +0100
Message-ID: <717e7cba0707170834l23e44142l6c1b4694cbef06be@mail.gmail.com>
References: <717e7cba0707030739h48ce146es8a0e67744af3f790@mail.gmail.com>
	<717e7cba0707030814h2de28c4fx8b672b518a9c008d@mail.gmail.com>
	<717e7cba0707030818m2e646709wea0e8a5306904f79@mail.gmail.com>
	<200707040308.l643826W014886@toshiba.co.jp>
	<717e7cba0707040500y1bf24073x59d4c6621b25292b@mail.gmail.com>
	<468BC7AE.8060303@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468BC7AE.8060303@cpsc.ucalgary.ca>
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

On 7/4/07, Rennie deGraaf <degraaf@cpsc.ucalgary.ca> wrote:
> Are you getting messages similar to "ip_rt_bug" in dmesg when incoming
> packets get redirected?  If so, see this thread:
> http://lists.netfilter.org/pipermail/netfilter-devel/2007-May/027849.html

Just so thread won't stay unresolved - bug was on my side - forgot to
swap bytes in ip address in message going one direction, but others
were correct.

> As for wireshark, I think that it sees incoming packets before netfilter
> does and outgoing packets after netfilter finishes with them.  That
> would explain the behaviour that you're seeing.

That's right. Thank you.
