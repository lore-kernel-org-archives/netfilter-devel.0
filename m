From: =?windows-1252?Q?Tom=E1=9A_Lejdar?= <tomas.lejdar@i.cz>
Subject: Re: libiptc memory leak - PATCH
Date: Mon, 28 Apr 2003 09:14:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EACD4D1.90704@i.cz>
References: <3EA46FDE.6040806@i.cz> <20030427125345.GD990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20030427125345.GD990@sunbeam.de.gnumonks.org>
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
I thing there is no problem, the memory is freed only when the
function next_chain returns NULL and run through the chains is on the end.
In the next call of first_chain() is memory alocated again in 
populate_cache().

Is there something wrong in my idea ?
T.v.L


Harald Welte wrote:
I cannot accept this patch It would basically mean that something like:

>first_chain()
>next_chain()
>first_chain()
>
>would no longer work.
>
>we need an explicit free_handle that cleans up all allocated regions
>instead.  Patches are welcome.
>  
>
