From: Tim Vandermeersch <tim.vandermeersch@pandora.be>
Subject: Re: easy questions about matches implementation
Date: Wed, 04 Jun 2003 19:24:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EDE2B42.5020706@pandora.be>
References: <000001c32abc$cb7a1620$0300000a@juan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Juan Torres <islero77@telefonica.net>
In-Reply-To: <000001c32abc$cb7a1620$0300000a@juan>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Juan Torres wrote:

>       
>       Hello, maybe it's a very easy question, but I'm studying the
>match ipt_multiport.c and I don't understand one thing:
>       
>       Why, in the last lines, it registers the match with
>ipt_register_match (&multiport_match) and, in the next line, it
>unregisters the match with ipt_unregister_match (&multiport_match)? How
>it works? 
>       
>       Is it because we only register when we read a rule that uses the
>multiport module, and just after we unregister again the match?
>       
>       What is the function of the last line MODULE_LINE ("GPL");?
>       
>       Where can I find more information about these questions? (I have
>read the Netfilter Hacking HOWTO)
>       
>       
>       Thank you very much for your help
>       
>       
>       Now I write the last lines of the file ipt_multiport.c:
>       
>       
>       static struct ipt_match multiport_match
>       = { { NULL, NULL }, "multiport", &match, &checkentry, NULL,
>THIS_MODULE };
>       
>       static int __init init(void)
>       {
>       	return ipt_register_match(&multiport_match);
>       }
>       
>       static void __exit fini(void)
>       {
>       	ipt_unregister_match(&multiport_match);
>       }
>       
>       module_init(init);
>       module_exit(fini);
>       MODULE_LICENSE("GPL");
>             
>        
>  
>
Read the Kernel Module Programming Guide.

When you load the module the function init is called (or another 
function you specify with module_init(some_function_name); ). In this 
function you register your match with iptables by calling 
ipt_register_match(); .
When you unload the module the function fini is called (or another 
function you specify with module_exit(some_function_name); ). In this 
function you unregister your match with iptables by calling 
ipt_unregister_match(); .

MODULE_LICENSE("GPL"); is a macro wich sets the module license, GPL in 
this case.

Regards,
Tim

PS: I'm not a kernel guru so correct me if I'm wrong.
