From: MYRIAM15 <MYRIAM15@terra.es>
Subject: avoid some indicative messages
Date: Wed, 27 Aug 2003 23:24:10 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <12bff612dda5.12dda512bff6@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Language: es
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

Hi, 
Maybe it is a stupid question. It's just that use a C program that if 
certain conditions are true, it adds rules. But every time I start the 
program, I want to be sure that previous rules that could have been 
created, they must be deleted, so the C program also does it. In this 
case, if a rule itself has not been created, some messages are printed 
that basically say: "that rule cannot be deleted because it doesn't 
exist". My question then is: is there any way to avoid these messages?

Thank you very much in advance
Miriam
