From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter question
Date: Sun, 20 Nov 2016 09:55:15 -0800
Message-ID: <1479664515.8455.374.camel@edumazet-glaptop3.roam.corp.google.com>
References: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
         <CANn89iLr-Zf2W5MW47QtKo17915UoryZentihKt1SMv7NP_dOw@mail.gmail.com>
         <20161116150200.GH30581@breakpoint.cc>
         <1479309789.8455.194.camel@edumazet-glaptop3.roam.corp.google.com>
         <20161117000725.GK30581@breakpoint.cc>
         <1479623583.8455.358.camel@edumazet-glaptop3.roam.corp.google.com>
         <CAGUFhKwQTRRJpfGi2fRkFfGdpLYMN-2F9G+dEsavM7UGbkjjdA@mail.gmail.com>
         <1479663097.8455.367.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Eric D <ericd@miromedia.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34948 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbcKTRzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Nov 2016 12:55:18 -0500
Received: by mail-pg0-f68.google.com with SMTP id p66so26171604pga.2
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Nov 2016 09:55:17 -0800 (PST)
In-Reply-To: <1479663097.8455.367.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2016-11-20 at 09:31 -0800, Eric Dumazet wrote:

> Thanks Eric, I will test the patch myself, because I believe we need it
> asap ;)


Current net-next without Florian patch :

lpaa24:~# time for f in `seq 1 2000` ; do iptables -A FORWARD ; done

real	0m12.856s
user	0m0.590s
sys	0m11.131s


perf report ...; perf report ->

    47.45%  iptables  [kernel.kallsyms]  [k] pcpu_alloc_area                      
     8.49%  iptables  [kernel.kallsyms]  [k] memset_erms                          
     7.35%  iptables  [kernel.kallsyms]  [k] get_counters                         
     2.87%  iptables  [kernel.kallsyms]  [k] __memmove                            
     2.33%  iptables  [kernel.kallsyms]  [k] pcpu_alloc                           
     2.07%  iptables  [kernel.kallsyms]  [k] _find_next_bit.part.0                
     1.62%  iptables  xtables-multi      [.] 0x000000000001bb9d                   
     1.25%  iptables  [kernel.kallsyms]  [k] page_fault                           
     1.01%  iptables  [kernel.kallsyms]  [k] memcmp                               
     0.94%  iptables  [kernel.kallsyms]  [k] translate_table                      
     0.76%  iptables  [kernel.kallsyms]  [k] find_next_bit                        
     0.73%  iptables  [kernel.kallsyms]  [k] filemap_map_pages                    
     0.68%  iptables  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string       
     0.54%  iptables  [kernel.kallsyms]  [k] __get_user_8                         
     0.54%  iptables  [kernel.kallsyms]  [k] clear_page_c_e                

After patch :

lpaa24:~# time for f in `seq 1 2000` ; do iptables -A FORWARD ; done

real	0m3.867s
user	0m0.559s
sys	0m2.216s

    22.15%  iptables  [kernel.kallsyms]  [k] get_counters                           
     5.85%  iptables  xtables-multi      [.] 0x000000000001bbac                     
     3.99%  iptables  [kernel.kallsyms]  [k] page_fault                             
     2.37%  iptables  [kernel.kallsyms]  [k] memcmp                                 
     2.19%  iptables  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string         
     1.89%  iptables  [kernel.kallsyms]  [k] translate_table                        
     1.78%  iptables  [kernel.kallsyms]  [k] memset_erms                            
     1.74%  iptables  [kernel.kallsyms]  [k] clear_page_c_e                         
     1.73%  iptables  [kernel.kallsyms]  [k] __get_user_8                           
     1.72%  iptables  [kernel.kallsyms]  [k] perf_iterate_ctx                       
     1.21%  iptables  [kernel.kallsyms]  [k] handle_mm_fault                        
     0.98%  iptables  [kernel.kallsyms]  [k] unmap_page_range          

So this is a huge win. And I suspect data path will also gain from all
pcpu counters being in the same area of memory (this is where I am very interested)


