From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_ACCOUNT accounting target released
Date: Tue, 27 Apr 2004 02:59:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408DB05E.6010706@trash.net>
References: <200404131731.02001.thomas.jarosch@intra2net.com> <200404261336.08119.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200404261336.08119.thomas.jarosch@intra2net.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thomas Jarosch wrote:
>>I'm pleased to announce the first alpha release
>>of the high performance ipt_ACCOUNT target module.
>>
>>You can find it here:
>>http://www.intra2net.com/opensource/ipt_account/
> 
> 
> Did anyone had a chance to take a look?
> I really would like to see this one in netfilter CVS ;-)

The pom-ng tar has the include and net directory in the
ACCOUNT directory. You need to place them inside the
linux directory. Also, the target is very long (>1000 lines)
and formatted improperly, this makes it hard to review.
Please stick to Documentation/CodingStyle, especially
regaring overly long lines (>80 chars) and wasted lines:

     if (table_nr == -1)
     {

should be:

     if (table_nr == -1) {

C-style comments are prefered over C++-style comments.
It also looks like some common blocks of code could
be placed in a seperate function, for example the inner
blocks in ipt_account_handle_get_data(). Why does it
need a PAGE_SIZE >= 4096 ?

Please post the patch to the list for easier review.

Regards
Patrick

> 
> Thomas
