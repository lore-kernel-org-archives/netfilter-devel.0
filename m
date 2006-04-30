From: "George P Nychis" <gnychis@cmu.edu>
Subject: changed "random" patch for higher precision
Date: Sun, 30 Apr 2006 00:00:57 -0400 (EDT)
Message-ID: <33328.128.2.140.234.1146369657.squirrel@128.2.140.234>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

I modified the "random" patch to support high precision averages ... the original random only supports 1-99% in integer intervals

The original patch did this by having an 8 bit integer, reading random bytes from the kernel into an 8 bit integer, and testing between 2 and 252 (1*2.55 and 99*2.55 ... 2.55 coming from 255/100).

Regardless of how the original patch worked, I use a 32 bit integer to support extremely high precision probabilities and changed the ranges to UINT_MAX instead of 255, plus other changes.

I tested it pretty rigurously on the 2.4 kernel because i'm working on a project right now which required high precision drop probabilities

My main question is, should i request changes to the random patch, or completely create a new patch and argument?

Thanks!
George
