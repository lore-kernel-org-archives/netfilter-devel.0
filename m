From: Chris Lowth <chris@lowth.com>
Subject: Re: Writing new Netfilter Modules
Date: Sun, 26 May 2002 23:08:26 +0100
Message-ID: <3CF15CDA.6080105@lowth.com>
References: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gingold Tomasz <tomasz.gingold@siemens.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.de>
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

You could try "Rope", which allows modules to be written using a 
scripting language that doesnt required kernel development.
You get access to the vast majority of IP/UDP and TCP headers plus the 
data payload, conntrack, packet marks and other facilities.
Currently this is for kernel 2.4.x only - 2.6.x will be covered shortly.

Even if your eventual module isnt written in Rope, it does provide a way 
of playing with ideas (protyping) in a safe environment before 
committing them to C.

http://www.lowth.com/rope

Chris

Gingold Tomasz wrote:

>Hello,
>
>i want to write my own netfilter module. Can anybody tell me how to start?
>Are there any tutorials/documents which could help?
>
>Up to now i have found the "Linux netfilter Hacking HOWTO", especially
>chapter 4 "Information for Programmers.
>Is this the only help i can obtain?
>
>
>Another question: 
>I have found on www.netfilter.org <www.netfilter.org>  the following statement: 
>"netfilter and iptables are building blocks of a framework inside the Linux <http://www.kernel.org/>  2.4.x and 2.6.x kernel"
>Does this mean, that netfilter and iptables are part of the kernel and don´t have to be installed?
>
>thanks for helping
>gingold tomasz
>berlin
>  
>
