From: Martijn Lievaart <m@rtij.nl>
Subject: Re: [RFC] iptables namespaces
Date: Fri, 07 Sep 2007 23:09:59 +0200
Message-ID: <46E1BE27.3050401@rtij.nl>
References: <20070907180204.GA460@ekonomika.be>	<20070907184642.GA4728@outback.rfc2324.org>
	<20070907190601.GA18714@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070907190601.GA18714@ekonomika.be>
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

Steven Van Acker wrote:
> On Fri, Sep 07, 2007 at 08:46:42PM +0200, Maximilian Wilhelm wrote:
>   
>>> The result is that for 1 minute, some traffic can get through the firewall rules
>>> while other can not. We have had problems with spam getting through to 
>>> mailservers behind the firewall, because not all firewall rules were loaded.
>>>       
>> That problem can be solved.
>> man iptables-restore
>>     
>
> iptables-restore takes a file as input, not a series of iptables
> commands. This means I would have to edit the file manually, not
> something I want to do with 7000 firewall rules.
>   

The write a script. I use Perl for this, but then, I'm a freak. But most 
existing scripts can be trivialy modified to produce a file which can be 
fed to iptables-restore.

Something along the lines of (completely untested, my bash is very rusty):

IPTABLES=writeit
 >rulez
#IPTABLES=/sbin/iptables # To slow!

function writeit {
   echo $@ >>rulez
}

$IPTABLES -A INPUT -p tcp ... etc

You'll have to write some preamble and COMMIT afterwards, that is left 
as an execise for the reader.

HTH,
M4
