From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 15:18:58 +0200
Message-ID: <200604281518.59463.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it>
	<200604281444.50982.max@nucleus.it>
	<Pine.LNX.4.58.0604281455520.20380@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0604281455520.20380@blackhole.kfki.hu>
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

On Friday 28 April 2006 2:58 pm, Jozsef Kadlecsik wrote:

> Why don't you choose an array and its indices? Array size could be
> specified by module parameter if the default were not sufficient for
> someone.

I would need a way to get the index.
If I put information back in the rule descriptor I can just store a pointer 
(the ultimate array index). If I don't touch the descriptor I'm stuck with a 
pointer to the descriptor and any information I can obtain with it, but no 
unique identifier that is immediately be used as an index in an array.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
