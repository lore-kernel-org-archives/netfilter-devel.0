From: primero <primero@fastwebnet.it>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 11:17:23 +0200
Message-ID: <42D77F23.80403@fastwebnet.it>
References: <42D6AD2C.5070304@fastwebnet.it>
	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
	<42D76E84.7080906@fastwebnet.it>
	<Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:

>>each libipt_MATCH has to call a register_match() in his init function passing
>>an "iptables_match" structure has argument that is referred as "me" inside the
>>register_match function.
>>
>>in my particular case me->version is equal to IPTABLES_VERSION (check out the
>>libipt_tcp.c).
>>    
>>
>
>  
>
i think i should have specified that i'm not an expert coder ... maybe 
i'm not a coder at all ;)

>me->version might just be null, surprise, surprise.
>  
>
Ok, if it would be null this expression :

if (strcmp(me->version, program_version) != 0) {
                fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
                        program_name, me->name, me->version, 
program_version);
                exit(1);
        }

should return a < 0 value and print the error string ? ... i get a 
segmentation faul instead

>I only see a 'me' member in the kernel interface, e.g. struct ipt_match, and 
>'me' is a struct module *. And the "version" member of struct module * is set 
>by MODULE_VERSION() macro AFAICG.
>
>
>  
>
I'll look for this MACRO.


>Jan Engelhardt
>  
>

thanks
Francesco
