From: Patrick McHardy <kaber@trash.net>
Subject: Re: MARK: targinfosize 8 != 4
Date: Tue, 13 Dec 2005 13:01:42 +0100
Message-ID: <439EB826.3070002@trash.net>
References: <00fe01c5ffb5$f0a7cf20$455f030a@askeyrd3>
	<20051213091820.GA1021@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: DervishD <lartc@dervishd.net>
In-Reply-To: <20051213091820.GA1021@DervishD>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

DervishD wrote:
>     Hi Salim :)
> 
>  * Salim <salim.si@askey.com.tw> dixit:
> 
>>   I got this problem while trying to shape traffic with iptables MARK and
>>HTB.
>>
>>MARK: targinfosize 8 != 4
>>
>>--set-mark gives "invalid argument" error message.
>>
>>Kernel version is 2.4.29 (some patches from patch o matic applied)
>>Iptables version 1.3.4
>>
>>Intel x86 architecture.
>>
>>I saw this problem discussed in a few places, but the discussions didn't
>>come to a conclusion or solution.
> 
> 
>     You've hit a bug in iptables :( I've notified in the bugzilla but
> I have had no answers. You're building iptables with no shared
> libraries (NO_SHARED_LIBS=1). This means that the code in iptables,
> when loading the "modules" for the matches and targets is taking a
> slightly different code path. The problem is that the MARK target
> has two versions, 0 and 1, and kernel 2.4.x (at least until 31)
> supports only version 0. If you don't use share libraries in
> iptables, both versions are loaded and v1 is used instead of v2.
> Unfortunately, v1 has a bigger data structure than v0 and your kernel
> complaints.

That can't be the reason, all revisions of a single match/target are
in the same object file and the supported revision is (supposed to be)
probed. Salim, can you send a strace of the failing iptables command?
