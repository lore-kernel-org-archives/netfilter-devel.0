From: Robert de Bath <list-netfilter@debath.co.uk>
Subject: Re: Iptables 1.3.1 still not very fast.
Date: Sat, 2 Apr 2005 11:11:37 +0100 (BST)
Message-ID: <63151cd79ef0f095@mayday.cix.co.uk>
References: <89b63d049739b257@mayday.cix.co.uk>
	<Pine.LNX.4.61.0504021048050.29334@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504021048050.29334@filer.marasystems.com>
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

On Sat, 2 Apr 2005, Henrik Nordstrom wrote:

> On Fri, 1 Apr 2005, Robert de Bath wrote:
>
>> My problem is that I think that libiptc looks evil and I really don't
>> want to dive into messing with that code. So how can I help to make
>> libiptc run as fast as I'd like it to?
>
> First step is to get a profile on where the time is spent...
>
>  gperf/OProfile/FunctionCheck

No problem, top of the file is ...

Each sample counts as 0.01 seconds.
   %   cumulative   self              self     total
  time   seconds   seconds    calls   s/call   s/call  name
  67.82    345.66   345.66   217459     0.00     0.00  iptcc_find_label
  27.98    488.30   142.64    20516     0.01     0.01  iptcc_find_chain_by_offset
   3.70    507.18    18.87    20520     0.00     0.00  iptc_insert_chain
   0.15    507.94     0.76        1     0.76   216.53  display_tree
   0.05    508.21     0.27    73850     0.00     0.00  iptc_append_entry
   0.04    508.41     0.20   114889     0.00     0.00  cache_add_entry
   0.04    508.60     0.19    50715     0.00     0.00  netmask4
   0.04    508.79     0.19        1     0.19     0.19  compact_tree
   0.02    508.91     0.12    73851     0.00     0.00  iptcc_compile_rule
   0.02    509.03     0.12        1     0.12   161.89  parse_table
   0.02    509.12     0.09    20520     0.00     0.00  iptcc_compile_chain_offsets
...
   0.00    509.78     0.02        1     0.02   130.59  delete_all_chains
...
   0.00    509.82     0.00        1     0.00   161.89  iptc_init


I think that's a pretty pointy finger there :-)

Do you want any more of the file ?

How about:
granularity: each sample hit covers 2 byte(s) for 0.00% of 509.82 seconds

index % time    self  children    called     name
-----------------------------------------------
                32.61    0.00   20515/217459      iptcc_map_target [12]
                32.61    0.00   20515/217459      iptc_get_references
[17]
                32.61    0.00   20515/217459      iptc_delete_chain [11]
                32.61    0.00   20517/217459      iptc_flush_entries [16]
                32.61    0.00   20517/217459      iptc_create_chain [15]
                65.22    0.00   41030/217459      iptc_builtin [13]
               117.39    0.00   73850/217459      iptc_append_entry [5]
[2]     67.8  345.66    0.00  217459         iptcc_find_label [2]
-----------------------------------------------
                 0.12  161.77       1/1           iptc_init [7]
[6]     31.8    0.12  161.77       1         parse_table [6]
               142.64    0.00   20516/20516       iptcc_find_chain_by_offset [9]
                 0.20   18.93  114889/114889      cache_add_entry [18]
-----------------------------------------------

Note:
This run was a replacement of an existing set of chains by an updated set.

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                        <http://www.cix.co.uk/~mayday>
