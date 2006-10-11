From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: Re: new match extension to implement port knocking in one
Date: Wed, 11 Oct 2006 17:44:04 -0300
Message-ID: <c0db55360610111344p719fb8dbw5a4ed61ce2ff3186@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Rennie deGraaf wrote:
> If you're interested in port knocking, you might want to read this
> paper:  http://www.acsac.org/2005/abstracts/156.html  It covers security
> issues relating to port knocking in detail, and presents an architecture
> for solving most of them.

> Full disclosure:  I wrote that paper.  Feel free to contact me if you
> have questions.


Hi, I'm one of the developers of the netfilter extension to use portknocking.

In our implementation, for security, we are using the Tumbler
protocol, we found it simple yet powerful, check it out here:
http://tumbler.sourceforge.net/.

Well, hope to read you paper soon and give you some feedback.

Tell me what you think about our protocol.

-- 
Federico
