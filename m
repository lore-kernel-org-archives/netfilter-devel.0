From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Libipq terminating application abnormally!!
Date: Sat, 04 Dec 2004 23:23:08 +0100
Message-ID: <41B238CC.1020105@eurodev.net>
References: <20041204122025.6819.qmail@webmail32.rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, jmorris@intercode.com.au
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Manzoor <hpmanzoor@rediffmail.com>
In-Reply-To: <20041204122025.6819.qmail@webmail32.rediffmail.com>
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

Manzoor wrote:

>  
>I have created an IP based bandwidth management program which filters the packets coming through the machine using a traditional Token Bucket algorithm. It works right for sometime. But when I tested it for 3-4 hours by running the program in Redhat Linux 9, libipq terminates the program giving the following message:
>
>"passer:recieved message truncated."
>  
>

could you post the code or the part of code which is spotting that error 
message?

--
Pablo
